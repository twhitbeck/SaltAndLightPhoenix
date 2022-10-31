defmodule AuctionWeb.API.RegistrationView do
  use AuctionWeb, :view

  # def render("delete.json", %{registration: registration}) do
  # %{data: render_one(registrations, RegistrationView, "registration.json")}
  # end

  def render("registration.json", %{registration: registration}) do
    %{
      student_id: registration.id,
      class_id: registration.class_id,
      semester: registration.semester
    }
  end
end

# registration_path  DELETE  /api/registrations/:id                   AuctionWeb.RegistrationController :delete
