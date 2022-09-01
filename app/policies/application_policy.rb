# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def self.permit(roles, options)
    return unless roles.is_a? Array
    return if absent?(options[:to])

    options[:to].each do |action|
      define_method("#{action}?") do
        return permitted_role?(roles, @user.role) if options[:when].blank?

        send(options[:when]) and permitted_role?(roles, @user.role)
      end
    end
  end

  def self.absent?(val)
    val.nil? || val.none? || val.blank?
  end

  def permitted_role?(roles, role)
    roles.any?(role.to_sym)
  end
end
