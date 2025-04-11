module ApplicationHelper
  def edit_and_destroy_buttons(item)
    return if current_user.nil?

    edit = link_to('Update', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', item, method: :delete,
                                   form: { data: { turbo_confirm: "Are you sure ?" } },
                                   class: "btn btn-danger")
    raw("#{edit} #{del}")
  end

  # rounding is alredy included in rating_average-method, this code is for week 6 exercise 9
  def round(number)
    number.round(1)
  end
end
