##############################################################################################################
# Something very neat about the way Phoenix handles template files is that when Phoenix compiles,            #
# it turns every template file into its own render/2 function inside its view module.                        #
# The return value of the function is the resulting HTML from the template!                                  #
# This means that, yes, rendering is actually just another function and just another way to transform data.  #
# No HTML is stored on disk or in memory and it is fast.                                                     #
##############################################################################################################

defmodule AuctionWeb.RegistrationView do
  use AuctionWeb, :view
  alias AuctionWeb.RegistrationView

  def render("index.json", %{registration: registration}) do
    %{data: render_many(registration, PersonView, "registration.json")}
  end

  def render("show.json", %{registration: registration}) do
    %{data: render_one(registration, RegistrationView, "registration.json")}
  end

  def render("registration.json", %{registration: registration}) do
    %{
      id: registration.id,
      student: registration.student,
      class: registration.class,
      semester: registration.semester
    }
  end

  def message do
    "Hello from the view!"
  end
end
