mruby-webkit-jscore
===================

Seamless integration of JavaScriptCore into WebKit for DOM access for mRuby

Requires
===
* mruby-javascriptcore (JS bindings for mruby)

Example
===
```ruby
Gtk::init
v = WebKit::WebView.new
v.load_html_string("<html></html>", nil)
v.signal_connect("notify::load-status") do
  if v.get_load_status == WebKit::LoadStatus::FINISHED
    go=v.get_main_frame.get_global_context.getGlobalObject
    doc = go.document
    nl = doc.getElementsByTagName.call("html")
    nl.each do |q| p q end
    
    Gtk.main_quit
  end
end

Gtk.main
```
