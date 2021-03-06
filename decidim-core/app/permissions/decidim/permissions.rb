# frozen_string_literal: true

module Decidim
  class Permissions < DefaultPermissions
    def permissions
      return permission_action unless permission_action.scope == :public

      read_public_pages_action?
      locales_action?
      component_public_action?
      search_scope_action?

      return permission_action unless user
      return user_manager_permissions if not_admin? && user_manager?

      manage_self_user_action?
      authorization_action?
      follow_action?
      amend_action?
      notification_action?
      conversation_action?
      user_group_action?
      user_group_invitations_action?

      permission_action
    end

    private

    def read_public_pages_action?
      return unless permission_action.subject == :public_page &&
                    permission_action.action == :read

      allow!
    end

    def locales_action?
      return unless permission_action.subject == :locales

      allow!
    end

    def component_public_action?
      return unless permission_action.subject == :component &&
                    permission_action.action == :read

      return allow! if component.published?
      return allow! if user_can_admin_component?
      return allow! if user_can_admin_component_via_space?

      disallow!
    end

    def search_scope_action?
      return unless permission_action.subject == :scope

      toggle_allow([:search, :pick].include?(permission_action.action))
    end

    def manage_self_user_action?
      return unless permission_action.subject == :user

      toggle_allow(context.fetch(:current_user, nil) == user)
    end

    def authorization_action?
      return unless permission_action.subject == :authorization

      authorization = context.fetch(:authorization, nil)

      case permission_action.action
      when :create
        toggle_allow(authorization.user == user && not_already_active?(authorization))
      when :update
        toggle_allow(authorization.user == user && !authorization.granted?)
      end
    end

    def follow_action?
      return unless permission_action.subject == :follow
      return allow! if permission_action.action == :create

      follow = context.fetch(:follow, nil)
      toggle_allow(follow&.user == user)
    end

    def amend_action?
      return unless permission_action.subject == :amendment
      return allow! if permission_action.action == :create
      return allow! if permission_action.action == :reject
      return allow! if permission_action.action == :promote
      return allow! if permission_action.action == :accept

      amendment = context.fetch(:amendment, nil)
      toggle_allow(amendment&.amender == user)
    end

    def notification_action?
      return unless permission_action.subject == :notification
      return allow! if permission_action.action == :read

      notification = context.fetch(:notification, nil)
      toggle_allow(notification&.user == user)
    end

    def conversation_action?
      return unless permission_action.subject == :conversation
      return allow! if [:create, :list].include?(permission_action.action)

      conversation = context.fetch(:conversation, nil)
      toggle_allow(conversation.participants.include?(user))
    end

    def user_group_action?
      return unless permission_action.subject == :user_group
      return allow! if [:join, :create].include?(permission_action.action)

      user_group = context.fetch(:user_group)

      if permission_action.action == :leave
        user_can_leave_group = Decidim::UserGroupMembership.where(user: user, user_group: user_group).where.not(role: :creator).any?
        return toggle_allow(user_can_leave_group)
      end

      user_manages_group = Decidim::UserGroups::ManageableUserGroups.for(user).include?(user_group)
      toggle_allow(user_manages_group) if permission_action.action == :manage
    end

    def user_group_invitations_action?
      allow! if permission_action.subject == :user_group_invitations
    end

    def user_can_admin_component?
      new_permission_action = Decidim::PermissionAction.new(
        action: permission_action.action,
        scope: :admin,
        subject: permission_action.subject
      )
      Decidim::Admin::Permissions.new(user, new_permission_action, context).permissions.allowed?
    rescue Decidim::PermissionAction::PermissionNotSetError
      nil
    end

    def user_can_admin_component_via_space?
      Decidim.participatory_space_manifests.any? do |manifest|
        begin
          new_permission_action = Decidim::PermissionAction.new(
            action: permission_action.action,
            scope: :admin,
            subject: permission_action.subject
          )
          new_context = context.merge(current_participatory_space: component.participatory_space)
          manifest.permissions_class.new(user, new_permission_action, new_context).permissions.allowed?
        rescue Decidim::PermissionAction::PermissionNotSetError
          nil
        end
      end
    end

    def not_already_active?(authorization)
      Verifications::Authorizations.new(organization: user.organization, user: user, name: authorization.name).none?
    end

    def user_manager_permissions
      Decidim::UserManagerPermissions.new(user, permission_action, context).permissions
    end

    def not_admin?
      !user.admin?
    end

    # Whether the user has the user_manager role or not.
    def user_manager?
      user.role? "user_manager"
    end
  end
end
