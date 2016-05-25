module InheritedResources
  module BaseHelpers
    protected
      def resource_params
        parameters = respond_to?(:permitted_params) ? permitted_params : params
        rparams = [parameters[resource_request_name] || parameters[resource_instance_name] || {}]
        rparams << as_role if role_given?
        rparams
      end
  end
end