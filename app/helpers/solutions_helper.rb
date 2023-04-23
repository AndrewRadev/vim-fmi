module SolutionsHelper
  def solution_vimrc_link(solution)
    if solution.vimrc_revision_id?
      link_to '✅', [solution.user, solution.vimrc_revision]
    end
  end
end
