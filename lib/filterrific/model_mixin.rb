module Filterrific::ModelMixin
    
  def self.included(base)
    base.send :extend, ClassMethods
  end

  module ClassMethods

    # Adds filterrific behavior to class when called like so:
    # 
    # filterrific, :defaults => { :sorted_by => "created_at_asc" }
    #
    def filterrific(options = {})
      send :include, InstanceMethods
      cattr_accessor :default_filterrific_params
      self.default_filterrific_params = (options[:defaults] || {}).stringify_keys
    end

    # Returns AR relation based on given filterrific_param_set.
    #
    # ModelClass.filterrific_find(@filterrific_param_set)
    #
    def filterrific_find(filterrific_param_set)
      unless filterrific_param_set.is_a?(FilterrificParamSet)
        raise(ArgumentError, "Invalid FilterrificParamSet: #{ filterrific_param_set.inspect }")
      end

      # set initial ar_proxy to including class
      ar_proxy = self
      
      # apply filterrific params
      self.filterrific_scope_names.each do |scope_name|
        scope_param = filterrific_param_set.send(scope_name)
        next if scope_param.blank? # skip blank scope_params
        ar_proxy = ar_proxy.send(scope_name, scope_param)
      end

      ar_proxy
    end

    # Returns Array all filter scope names
    def filterrific_scope_names
      scopes.map{ |s| s.first.to_s }
    end

  end

end
