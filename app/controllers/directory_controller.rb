class DirectoryController < ApplicationController
  respond_to :html

  SearchField = Struct.new(:id, :name)

  def show
    @contacts = Contact.
      search((params[:field] || "name"), params[:term]).
      by_last_initial(params[:last_i]).
      by_groups(params[:group_ids]).
      by_sections(params[:section_ids]).
      by_types(params[:types])
      .select(:id, :family_name, :given_name, :phone, :pager, :alpha_pager, :email, :employment_ends_on)
      .to_json(only: [:id, :family_name, :given_name, :phone, :pager, :alpha_pager, :email])
    @search_fields = [
      SearchField.new("name", "Name"),
      SearchField.new("phone", "Phone"),
      SearchField.new("fax", "Fax"),
      SearchField.new("pager", "Pager"),
      SearchField.new("alpha_pager", "Alpha pager"),
      SearchField.new("email", "Email")
    ]
  end
end
