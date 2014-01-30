unless ::Object.const_defined?(:WebKit)
  GirFFI::setup :WebKit
end

module WebKit
  self::WebFrame
  
  self::Lib.attach_function :webkit_web_frame_get_global_context,[:pointer],:pointer
  
  class WebFrame
    define_method :get_global_context do
      ptr = WebKit::Lib.send(:webkit_web_frame_get_global_context, self.to_ptr)
      ctx = JavaScriptCore::GlobalContext.wrap(ptr)
      next ctx
    end
  end
end

module JS
  module JS::Object
    def is_node_list
      if JS.execute(context,"this instanceof NodeList;",self) == true
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
  
  module JS::Value
    class << self
      alias :__to_ruby__ :to_ruby
    end
    
    def self.to_ruby v,ctx=nil
      if v.getType == JavaScriptCore::ValueType::OBJECT and (o=__to_ruby__(v,ctx)).is_node_list
        o.extend JS::ObjectIsNodeList
        return o
      end

      return __to_ruby__(v, ctx)
    end
  end
end
