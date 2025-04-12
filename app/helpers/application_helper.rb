module ApplicationHelper
  def edit_and_destroy_buttons_admin(item)
    return if current_user.nil?

    edit = link_to('Update', url_for([:edit, item]), class: "btn btn-primary")
    if @admin
      del = link_to('Destroy', item, class: "btn btn-danger", data: { 'turbo-method': :delete, turbo_confirm: "Are you sure?" })
    end
    raw("#{edit} #{del}")
  end

  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Update', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', item, class: "btn btn-danger", data: { 'turbo-method': :delete, turbo_confirm: "Are you sure?" })
    raw("#{edit} #{del}")
  end

  # rounding is alredy included in rating_average-method, this code is for week 6 exercise 9
  def round(number)
    number.round(1)
  end
end
