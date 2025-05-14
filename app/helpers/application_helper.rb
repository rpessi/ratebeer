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

  def destroy_button_admin(item)
    puts "destroy_button_admin, #{current_user.username}"
    conf_msg = "Are you sure you want to remove #{item.name} and all beers associated with it?"
    del = link_to('Delete', item, class: "btn btn-sm btn-danger",
                                  data: { 'turbo-method': :delete,
                                          turbo_confirm: conf_msg })
    raw(del.to_s)
  end

  # rounding is alredy included in rating_average-method, this code is for week 6 exercise 9
  def round(number)
    number.round(1)
  end
end
