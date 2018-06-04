module OrderExtend
  def per_project
    component.settings.vote_per_project?
  end

  def limit_project_reached?
    total_projects == number_of_projects
  end

  def total_projects
    projects.count
  end

  def remaining_projects
    number_of_projects - projects.count
  end

  def can_checkout?
    if component.settings.vote_per_project?
      limit_project_reached?
    else
      total_budget.to_f >= minimum_budget
    end
  end

  def number_of_projects
    component.settings.total_projects
  end
end

Decidim::Budgets::Order.class_eval do
  validates :total_budget, numericality: {
        less_than_or_equal_to: :maximum_budget
  }, unless: :per_project

  validates :total_projects, numericality: {
    less_than_or_equal_to: :number_of_projects
  }, unless: :per_project

  validates :total_projects, numericality: {
    less_than_or_equal_to: :number_of_projects
  }, if: :per_project
  prepend(OrderExtend)
end