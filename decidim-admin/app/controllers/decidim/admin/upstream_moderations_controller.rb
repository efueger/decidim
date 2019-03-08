# frozen_string_literal: true

module Decidim
  module Admin
    # This controller allows admins to manage moderations in a participatory process.
    class UpstreamModerationsController < Decidim::Admin::ApplicationController
      helper_method :upstream_moderations, :allowed_to?

      def index
        enforce_permission_to :read, :moderation
      end

      def make_visible
        enforce_permission_to :make_visible, :moderation

        Admin::MakeVisibleUpstreamResource.call(upstream_reportable, current_user) do
          on(:ok) do
            flash[:notice] = I18n.t("reportable.unreport.success", scope: "decidim.moderations.admin")
            redirect_to upstream_moderations_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("reportable.unreport.invalid", scope: "decidim.moderations.admin")
            redirect_to upstream_moderations_path
          end
        end
      end

      private

      def upstream_moderations
        @upstream_moderations ||= begin
          if params[:visible]
            participatory_space_upstream_moderations.where(hidden_at: nil)
          else
            participatory_space_upstream_moderations.where.not(hidden_at: nil)
          end
        end
      end

      def upstream_reportable
        @upstream_reportable ||= participatory_space_upstream_moderations.find(params[:id]).upstream_reportable
      end

      def participatory_space_upstream_moderations
        @participatory_space_upstream_moderations ||= Decidim::UpstreamModeration.where(participatory_space: current_participatory_space)
      end
    end
  end
end
