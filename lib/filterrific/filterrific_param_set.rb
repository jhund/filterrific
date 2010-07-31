# FilterParamSet is a container to store FilterParams for a resource class that is filterrific
class FilterrificParamSet

  attr_accessor :resource_class
  
  def initialize(resource_class, filterrific_params = {})

    self.resource_class = resource_class

    # use either passed in options or resource class' default list_options
    # don't merge them. This causes trouble if an option is set to nil
    # by the user, then it will be overriden by default list_options
    # You might wonder "what if I want to change only one thing from the defaults?"
    # Persistence, baby. By the time you submit changes to one dimension, all the others
    # will be already initialized with the defaults.
    filterrific_params = resource_class.default_filterrific_params if filterrific_params.blank?
    
    # force all keys to strings
    filterrific_params.stringify_keys!

    # condition filterrific_params
    filterrific_params.each do |key, val|
      case
      when val.is_a?(Proc)
        # evaulate Procs
        filterrific_params[key] = val.call
      when val.is_a?(Array)
        # type cast integers
        filterrific_params[key] = filterrific_params[key].map { |e| e =~ /^\d+$/ ? e.to_i : e }
      when val =~ /^\d+$/
        # type cast integers
        filterrific_params[key] = filterrific_params[key].to_i
      end
    end

    # Define attr_accessor for each FilterrificScope
    # on FilterrificParamSet instance and assign values from options
    resource_class.filterrific_scope_names.each do |scope_name|
      self.class.send(:attr_accessor, scope_name)
      v = options[scope_name.to_s]
      self.send("#{ scope_name }=", v)  if v.present?
    end
    
  end
  
  # Returns FilterrificParams as hash (used for URL params and serialization)
  def to_hash
    returning({}) do |h|
      resource_class.filterrific_scope_names.each do |scope_name|
        param_value = self.send(scope_name)
        case
        when param_value.blank?
          # do nothing
        when param_value.is_a?(Proc)
          # evaluate Proc so it can be serialized
          h[scope_name.to_s] = param_value.call
        else
          h[scope_name.to_s] = param_value
        end
      end
    end
  end
  
  # Returns true if this FilterrificParamSet is not the model's default.
  def customized?
    resource_class.default_filterrific_params != to_hash
  end
  
end
