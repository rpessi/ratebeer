module UsersHelper
  def user_edit_and_destroy_buttons(item, current_user)
    return unless item == current_user

    edit = link_to('Update', url_for([:edit, item]), class: "btn btn-primary")
    del = link_to('Destroy', item, class: "btn btn-danger", data: { 'turbo-method': :delete, turbo_confirm: "Are you sure?" })
    raw("#{edit} #{del}")
  end
end
