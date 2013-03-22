GirBind.ensure(:WebKit)

module WebKit
  load_class(:WebFrame) do
    f = FFIBind::Function.add_function(WebKit.ffi_lib,"webkit_web_frame_get_global_context",[:pointer],:pointer)
  
    define_method :get_global_context do
      ptr = f.invoke(self)
      ctx = JS::JSGlobalContext.wrap(ptr)
      next ctx
    end
  end
end

module JS
  module JS::Object
    def is_node_list
	  if context.execute("this instanceof NodeList;",self) == true
		return true
	   end
	   return false
    end
  end
  
  module JS::ObjectIsNodeList
    include Enumerable
    def each
      for i in 0..self[:length]-1
        yield self[:item].call(i)
      end
    end
  end
  
  class JS::JSValue
    alias :__to_ruby__ :to_ruby
    def to_ruby
      if is_object and (o=to_object(nil)).is_node_list
        o.extend JS::ObjectIsNodeList
        return o
      end

      return __to_ruby__
    end
  end
end

JS::Object.use_method_missing
