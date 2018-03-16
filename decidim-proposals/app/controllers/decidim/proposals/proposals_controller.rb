# frozen_string_literal: true

module Decidim
  module Proposals
    # Exposes the proposal resource so users can view and create them.
    class ProposalsController < Decidim::Proposals::ApplicationController
      helper Decidim::WidgetUrlsHelper
      include FormFactory
      include FilterResource
      include Orderable
      include Paginable

      helper_method :officials_proposals
      helper_method :citizens_proposals
      helper_method :geocoded_proposals
      before_action :authenticate_user!, only: [:new, :create]

      def index
        @proposals = proposals_search

        @filter_origin = filter_origin?

        @voted_proposals = if current_user
                             ProposalVote.where(
                               author: current_user,
                               proposal: @proposals.pluck(:id)
                             ).pluck(:decidim_proposal_id)
                           else
                             []
                           end
        @param_list = params[:display_type] == "list"
        keep_filter_params

        if current_feature.settings.split_proposal_enabled? && feature_settings.official_proposals_enabled
          @officials_proposals = @proposals.officials.order(created_at: :asc).all
          @citizens_proposals =  @proposals.citizens.order(created_at: :asc).all
        else
          @proposals = paginate(@proposals)
          @proposals = reorder(@proposals)
        end

        @filter_origin = filter_origin?
      end

      def show
        @proposal = Proposal
                    .not_hidden
                    .where(feature: current_feature)
                    .find(params[:id])
        @report_form = form(Decidim::ReportForm).from_params(reason: "spam")
      end

      def new
        authorize! :create, Proposal

        @form = form(ProposalForm).from_params(
          attachment: form(AttachmentForm).from_params({})
        )
      end

      def create
        authorize! :create, Proposal

        @form = form(ProposalForm).from_params(params)

        CreateProposal.call(@form, current_user) do
          on(:ok) do |proposal|
            if proposal.feature.settings.upstream_moderation_enabled
              flash[:notice] = I18n.t("proposals.create.moderation.success", scope: "decidim")
            else
              flash[:notice] = I18n.t("proposals.create.success", scope: "decidim")
            end
            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.create.error", scope: "decidim")
            render :new
          end
        end
      end

      def edit
        @proposal = Proposal.not_hidden.where(feature: current_feature).find(params[:id])
        authorize! :edit, @proposal

        @form = form(ProposalForm).from_model(@proposal)
      end

      def update
        @proposal = Proposal.not_hidden.where(feature: current_feature).find(params[:id])
        authorize! :edit, @proposal

        @form = form(ProposalForm).from_params(params)
        UpdateProposal.call(@form, current_user, @proposal) do
          on(:ok) do |proposal|
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(proposal).path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("proposals.update.error", scope: "decidim")
            render :edit
          end
        end
      end

      def withdraw
        @proposal = Proposal.not_hidden.where(feature: current_feature).find(params[:id])
        authorize! :withdraw, @proposal

        WithdrawProposal.call(@proposal, current_user) do
          on(:ok) do |_proposal|
            flash[:notice] = I18n.t("proposals.update.success", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
          on(:invalid) do
            flash[:alert] = I18n.t("proposals.update.error", scope: "decidim")
            redirect_to Decidim::ResourceLocatorPresenter.new(@proposal).path
          end
        end
      end

      private

      def filter_origin?
       (params[:filter][:origin] != ("all" || nil)) if params[:filter]
      end

      def keep_filter_params
        @param_page = params[:page]
        @param_per_page = params[:per_page]
        @param_order = params[:order]
        @param_display_type = params[:display_type]
        @param_search_text = params[:filter][:search_text] if params[:filter]
        @param_activity = params[:filter][:activity] if params[:filter]
        @param_category_id = params[:filter][:category_id] if params[:filter]
        @param_scope_id = params[:filter][:scope_id] if params[:filter]
        @param_related_to = params[:filter][:related_to] if params[:filter]
        @param_origin = params[:filter][:origin] if params[:filter]
        @param_state = params[:filter][:state] if params[:filter]
      end

      def officials_proposals
        @officials_proposals.any?
      end

      def citizens_proposals
        @citizens_proposals.any?
      end

      def filter_origin?
       (params[:filter][:origin] != ("all" || nil)) if params[:filter]
      end

      def proposals_search
        search
          .results
          .not_hidden
          .includes(:author)
          .includes(:category)
          .includes(:scope)
      end

      def geocoded_proposals
        @geocoded_proposals ||= search.results.not_hidden.select(&:geocoded?)
      end

      def search_klass
        ProposalSearch
      end

      def default_filter_params
        {
          search_text: "",
          origin: "all",
          activity: "",
          category_id: "",
          state: "not_withdrawn",
          scope_id: nil,
          related_to: ""
        }
      end
    end
  end
end
