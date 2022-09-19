# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  crud_actions = %i[index new create show edit update destroy]
  crud_actions.each do |action|
    define_method("#{action}?") do
      return true
    end
  end

  def self.define_policy_actions(roles, options, role_check_signal)
    options[:to].each do |action|
      define_method("#{action}?") do
        return send(role_check_signal, roles) if options[:when].blank?

        send(options[:when]) and send(role_check_signal, roles)
      end
    end
  end

  def self.permit(roles, options)
    define_policy_actions(roles, options, 'permitted_role?')
  end

  def self.forbid(roles, options)
    define_policy_actions(roles, options, 'forbidden_role?')
  end

  def permitted_role?(roles)
    roles.any?(@user&.role&.to_sym)
  end

  def forbidden_role?(roles)
    roles.none?(@user&.role&.to_sym)
  end
end
