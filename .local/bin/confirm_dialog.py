# Copyright (c) 2023 <copyright mal1kc(mal1kc [at] proton [dot] me, mal1kc@proton.me )>
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# dependecies is gtk4 and python bindings
# 
#!/bin/env python3
import sys
import gi

gi.require_version("Gtk", "4.0")
from gi.repository import Gtk


def yes_clicked(args):
    # print(args)
    print("Confirmation box returned True")
    sys.exit(0)


def no_clicked(args):
    # print(args)
    print("Confirmation box returned False")
    sys.exit(1)


def on_keypress(keyval, keycode, state, user_data, win):
    if keycode == ord("q"):
        win.close()


if __name__ == "__main__":
    # Create a new application
    # Run the application
    if len(sys.argv) < 2:
        print("Usage: python confirm_dialog <title> <question>")
        sys.exit(1)

    dialog_title = sys.argv[1] or "dialog_title"
    question = dialog_title
    if len(sys.argv) > 2:
        question = sys.argv[2] or "question ?"

    def create_win(app):
        # win.present()
        # … create a new window
        win = Gtk.ApplicationWindow(application=app)

        keycont = Gtk.EventControllerKey()
        keycont.connect("key-pressed", on_keypress, win)
        win.add_controller(keycont)

        msg_dialog = Gtk.MessageDialog(transient_for=win)
        msg_dialog.set_title(dialog_title)
        # … with a button in it…
        main_box = Gtk.Box(
            orientation=Gtk.Orientation.VERTICAL,
            valign=Gtk.Align.CENTER,
            halign=Gtk.Align.CENTER,
        )
        main_box.set_margin_top(10)
        main_box.set_margin_bottom(10)
        main_box.set_margin_start(10)
        main_box.set_margin_end(10)
        btn_box = Gtk.Box(
            orientation=Gtk.Orientation.HORIZONTAL,
            valign=Gtk.Align.CENTER,
            halign=Gtk.Align.CENTER,
        )
        btn_box.set_margin_top(10)
        btn_box.set_margin_bottom(10)
        btn_box.set_margin_start(10)
        btn_box.set_margin_end(10)

        msg_dialog.set_child(main_box)
        question_lbl = Gtk.Label(label=question)
        main_box.append(question_lbl)
        main_box.append(btn_box)
        main_box.set_spacing(30)
        yes_btn = Gtk.Button(label="Yes")
        no_btn = Gtk.Button(label="No")
        # … which closes the window when clicked
        # btn.connect("clicked", lambda x: win.close())
        yes_btn.connect("clicked", yes_clicked)
        no_btn.connect("clicked", no_clicked)
        btn_box.append(yes_btn)
        btn_box.append(no_btn)
        btn_box.set_spacing(100)
        msg_dialog.present()

    app = Gtk.Application(application_id="xyz.mal1kc.confirm_dialog")
    app.connect("activate", create_win)

    app.run(None)
