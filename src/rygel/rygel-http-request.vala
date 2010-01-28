/*
 * Copyright (C) 2008-2010 Nokia Corporation.
 * Copyright (C) 2006, 2007, 2008 OpenedHand Ltd.
 *
 * Author: Zeeshan Ali (Khattak) <zeeshanak@gnome.org>
 *                               <zeeshan.ali@nokia.com>
 *         Jorn Baayen <jorn.baayen@gmail.com>
 *
 * This file is part of Rygel.
 *
 * Rygel is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Rygel is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software Foundation,
 * Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

internal errordomain Rygel.HTTPRequestError {
    UNACCEPTABLE = Soup.KnownStatusCode.NOT_ACCEPTABLE,
    BAD_REQUEST = Soup.KnownStatusCode.BAD_REQUEST,
    NOT_FOUND = Soup.KnownStatusCode.NOT_FOUND
}

/**
 * Base class for HTTP client requests.
 */
internal abstract class Rygel.HTTPRequest : GLib.Object, Rygel.StateMachine {
    public unowned HTTPServer http_server;
    private MediaContainer root_container;
    public Soup.Server server;
    public Soup.Message msg;
    private HashTable<string,string>? query;

    public Cancellable cancellable { get; set; }

    protected HTTPItemURI uri;
    public MediaItem item;

    public HTTPRequest (HTTPServer                http_server,
                        Soup.Server               server,
                        Soup.Message              msg,
                        HashTable<string,string>? query) {
        this.http_server = http_server;
        this.cancellable = new Cancellable ();
        this.root_container = http_server.root_container;
        this.server = server;
        this.msg = msg;
        this.query = query;
    }

    public async void run () {
        yield this.handle ();
    }

    protected virtual async void handle () {
        this.uri = new HTTPItemURI.from_string (this.msg.uri.path,
                                                this.http_server.path_root);

        if (this.uri.item_id == null) {
            this.handle_error (new HTTPRequestError.NOT_FOUND ("Not Found"));

            return;
        }

        yield this.find_item ();
    }

    protected virtual async void find_item () {
        // Fetch the requested item
        MediaObject media_object;
        try {
            media_object = yield this.root_container.find_object (
                                        this.uri.item_id,
                                        null);
        } catch (Error err) {
            this.handle_error (err);

            return;
        }

        if (media_object == null || !(media_object is MediaItem)) {
            this.handle_error (new HTTPRequestError.NOT_FOUND (
                                        "requested item '%s' not found",
                                        this.uri.item_id));
            return;
        }

        this.item = (MediaItem) media_object;
    }

    protected virtual void handle_error (Error error) {
        warning ("%s", error.message);

        uint status;
        if (error is HTTPRequestError) {
            status = error.code;
        } else {
            status = Soup.KnownStatusCode.NOT_FOUND;
        }

        this.end (status);
    }

    protected void end (uint status) {
        if (status != Soup.KnownStatusCode.NONE) {
            this.msg.set_status (status);
        }

        this.completed ();
    }
}

