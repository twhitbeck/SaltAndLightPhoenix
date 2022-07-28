defmodule Auction do
  alias Auction.{Repo, User, Password, Profile, Student, Class, Registration}
  #import Ecto.Changeset # Eliminate specifying Ecto.Changeset.cast, etc
  import Ecto.Query

  @repo Repo

 #######################################
 # conversion functions  - struct / map #
 ########################################
  def schema_to_map(schema) do
    schema
      |> Map.from_struct()
      |> Map.drop([:__meta__])
   end

  ################################################################
  # User functions  - for users on Phoenix side of umbrella      #
  ################################################################

  def get_user(id) do
     @repo.get!(User, id)  # returns %Auction.User{User info}
     #|> preload(profiles: :firstname)
  end

  def new_user, do: User.changeset_with_password(%User{})

  def insert_user(params) do
    %User{}
    |> User.changeset_with_password(params)
    |> @repo.insert
  end

  def get_user_by_username_and_password(username, password) do
    with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
      true <- Password.verify_with_hash(password, user.hashed_password) do
        user # true
      else   # false
        _ -> Password.dummy_verify
      end # Password.verify
  end  # def

  def get_user_lastname(id) do
    prid = Auction.get_user(id)
    nilprofile = Repo.preload(prid,:profiles).profiles
    case nilprofile do
      nil -> nil #check_nil()
      _ -> nilprofile.lastname
    end
    #Repo.get!(Profile, id).lastname
    #|> IO.inspect()
  end


  #################################################################
  # Profile functions  - for profiles on Phoenix side of umbrella #
  #################################################################
   def new_profile, do: Profile.changeset(%Profile{})
  #   Profile.changeset(%Profile{})   # Return a blank changeset

  ##########################################################################
  # Alternately Auction.Profile |> struct() in place of %Profile{}         #
  # %Profile{} is a struct - Kernel.struct/2 changes a map to a struct     #
  # changeset/2 - arg 1 is a struct, arg2 is a map of attributes           #
  # Attributes - need to be verified and updated - default is an empty map #
  ##########################################################################
  def insert_profile(params) do
    %Profile{}#Auction.Profile
     |> Profile.changeset(params)
     |> @repo.insert()
  end

  ##################################
  # returns a schema struct or nil #
  ##################################

  # Given a user id - return the user profile
  def get_profile(id) do
    @repo.get(Profile, get_profile_id(id))
  end

  # Given user id return the user profile id
  def get_profile_id(userid) do # seems crude  - is there a better way?
    query = from(Profile, where: [user_id: ^userid], select: [:id])
    Repo.all(query) |> Enum.at(0) |> Map.get(:id)
  end

  # Given a profile id return the user profile
  def get_profile_nil(id) do
    @repo.get(Profile, id)
  end

  # Given user id return a user profile changeset
  def show_profile(id) do # get profile given profile ID
    get_profile(id)  # convert to changeset
    |> Profile.changeset()
  end

  def check_nil() do
    nil
  end

 #stuff = Student.changeset(%Student{}, studentparams)
  def check_profile(id) do # check if there is a profile - for user ID
    prid = Auction.get_user(id)
    # If there exists a profile - nilprofile will be a profile struct
    # If ther is no profile     - nilprofile will be nil
    nilprofile = Repo.preload(prid,:profiles).profiles
    case nilprofile do
      nil -> nil #check_nil()
      _ -> show_profile(id)
    end
  end

  def get_profile_by(attrs) do
    @repo.get_by(Profile, attrs)
  end

  def update_profile(%Auction.Profile{} = profile, updates) do
    profile
      |> Auction.Profile.changeset(updates)
      |> @repo.update()
  end

  def edit_profile(id) do
    get_profile(id)
    |> Profile.changeset()
  end

  def delete_profile(%Auction.Profile{} = profile), do: @repo.delete(profile)

  #################################################################
  # Student functions  - for students on Phoenix side of umbrella #
  #################################################################

  #  Student.changeset(%Student{})   # Return a blank changeset
  def new_student, do:  Student.changeset(%Student{})

  def insert_student(params) do
    %Student{}#Auction.Student
     |> Student.changeset(params) # should return a change set with changes containing data
     |> @repo.insert()
  end

  # Fetches a single struct from the data store where
  # the primary key matches the given student id
  # returns a map
  def get_student(id) do
    @repo.get!(Student, id)
  end

  # Given user id return all students belonging to the user
  def get_student_id(userid) do # seems crude  - is there a better way?
    query = from(Student, where: [user_id: ^userid], select: [:id])
    Repo.all(query) |> Enum.at(0) |> Map.get(:id)
  end

  def get_student_profile(id) do
    get_profile(id)   # returns a struct
  end

  def show_student(id) do     # input student id - return a changeset
    get_student(id)          # returns a map
    |> Student.changeset()   # convert to changeset
  end

  def show_students(id) do # show all students for one user - getting user profile instead ERROR
    Auction.get_student_profile(id)
    Auction.get_user(id)
    |> @repo.preload(:students)    # as a struct containing a list of structs - students:
    |> show_students_changesets()  # a list of changesets
    #Enum.each(Auction.get_user(id),&IO.inspect/1)
  end

  def make_changeset(map) do
    Student.changeset(map)
  end

  def show_students_changesets(maplist) do
     student_list = maplist.students
     #for student <- student_list do
     Enum.map(student_list, &make_changeset/1)
  end

  def get_student_by(attrs) do
    @repo.get_by(Student, attrs)
  end

  def update_student(%Auction.Student{} = student, updates) do
    student
      |> Auction.Student.changeset(updates)
      |> @repo.update()
  end

  def edit_student(id) do
    get_student(id)
    |> Student.changeset()
  end

  def delete_student(%Auction.Student{} = student), do: @repo.delete(student)

  # Given user id return a list of student ids
  def get_student_ids(userid) do # seems crude  - is there a better way?
    query = from(Student, where: [user_id: ^userid], select: [:id])
    Repo.all(query) |> Enum.map(fn(x) -> x.id end)
  end

  # Given user id return a list of student maps
  def get_students(id) do #Get all students for one user - alternate method
    query = from(Student, where: [user_id: ^id], select: [:firstname, :grade, :birthday, :id, :updated_at, :user_id])
    Repo.all(query)  #brings back list of structs
  end

  # for one user - get one student by first name
  def get_student_id(userid, firstname) do
    query = from(Student, where: [user_id: ^userid], where: [firstname: ^firstname], select: [:id, :user_id])
    Repo.all(query)#, preload [:registrations]  #brings back list of structs
  end

   #stuff = Student.changeset(%Student{}, studentparams)
   def check_students(id) do # check if there are students
      user = Auction.get_user(id)
     # If there exists a student - nilstudent will be a list of student structs
     #nilstudents = Repo.preload(user,:students).students
     |> Repo.preload([:profiles, :students])
     #|> IO.inspect()
     #IO.puts("LAST NAME")
     #IO.inspect(nilstudents.profiles.lastname)
     #case nilstudents.profiles.lastname do
     #  nil -> nil #check_nil()
     #  _ -> #show_students(id)
     #end
 end

  ######################################################################
  # registration functions  - for students on Phoenix side of umbrella #
  ######################################################################

  #  Registration.changeset(%Registration{})   # Return a blank changeset
  def new_registration, do:  Registration.changeset(%Registration{})

  def insert_registration(params) do
    %Registration{}#Auction.Student
     |> Registration.changeset(params) # should return a change set with changes containing data
     |> @repo.insert()
  end

  # Fetches the student id associated with registration id
  def get_student_id_from_registration(id) do
     @repo.get!(Registration, id).student_id
  end
  # Fetches a single map from the data table where
  # the primary key matches the given id
  def get_registration(id) do      # id is the registration id
    @repo.get!(Registration, id)
  end

  def get_period(class_id) do
    @repo.get!(Period, class_id)
  end

  def get_section(section_id) do
    @repo.get!(Section, section_id)
  end

  def show_registration(id) do
     get_registration(id) # looks like a changeset
     |> Registration.changeset()
  end

   # Given semester return a list of registrations classes
  def get_registrations(semester) do #Get all students for one user - alternate method
    query = from(Registration)
    |> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher, class: :helper1, class: :helper2])
    Repo.all(query)  #brings back list of structs
  end

  #####################################
  # Get all registrations for student #
  #####################################
  def get_student_registrations(id)  do # id is student primary key id
      query = from(Registration, where: [student_id: ^id])
      #|> @repo.preload([class: :classtitle, class: :period, class: :section, class: :teacher, class: :helper1, class: :helper2])
      results = @repo.all(query)
  end

  ####################################
  # Get one registration for student #
  # Perhaps the first one            #
  ####################################
  def get_registration_by_one(student_id) do  # id is student primary key id
     Registration
       |> where([r],r.student_id == ^student_id)
       |> limit(1)
       |> @repo.all
  end

  #alternate syntax
  #def get_student_registrations(id)   # id is studeht primary key id
  #  query = from(Registrations, where: [student_id: id]
  #  Repo.all(query)
  #end

  def get_registration_by(attrs) do
    @repo.get_by(Registration, attrs)
  end

  def delete_registration(%Auction.Registration{} = registration), do: @repo.delete(registration)

 # def get_registrations(student_id) do #Get all registrations for one student - alternate method
 #   query = from(Registration, where: [student_id: ^students_id], select: [:registration_id])
 #   Repo.all(query)  #brings back list of structs
 # end

   #stuff = Student.changeset(%Student{}, studentparams)
   def check_students(id) do # check if there are students
      user = Auction.get_user(id)
     # If there exists a student - nilstudent will be a list of student structs
     #nilstudents = Repo.preload(user,:students).students
     |> Repo.preload([:profiles, :students])
     #|> IO.inspect()
     #IO.puts("LAST NAME")
     #IO.inspect(nilstudents.profiles.lastname)
     #case nilstudents.profiles.lastname do
     #  nil -> nil #check_nil()
     #  _ -> #show_students(id)
     #end
  end

  def get_fee(semester, fallfee, springfee) do
    cond do
      semester = 1 -> fallfee
      semester = 2 -> springfee
    end
      "fee unknown"
  end

  ###############################################################
  # id is registration id - return class for that registration. #
  ###############################################################
  def get_class_from_registration(id) do
    classid = get_registration(id).class_id
    |> Auction.get_class()
    |> @repo.preload([:classtitle,:period,:section,:teacher,:helper1,:helper2])
  end

  ###############################################################
  # id is class id - return class for that class.               #
  ###############################################################
  def get_class_from_classid(classid) do
    Auction.get_class(classid)
    |> @repo.preload([:classtitle,:period,:section,:teacher,:helper1,:helper2])
  end

  ##############################################################
  # Class functions  - for classes on Phoenix side of umbrella #
  ##############################################################

  #  Class.changeset(%Class{})   # Return a blank changeset
  def new_class, do:  Class.changeset(%Class{})

  def insert_class(params) do
    %Class{}#Auction.Student
     |> Class.changeset(params) # should return a change set with changes containing data
     |> @repo.insert()
  end

  # Fetches a single struct from the data store where
  # the primary key matches the given id
  def get_class(id) do
    @repo.get!(Class, id)
  end
  #|> @repo.preload(classtitle: [class: [registration: :student]])

  def get_teacher_name(id) do
    prof = get_profile(id)   # returns a struct
    prof.firstname <> " " <> prof.lastname
    # Enum.join([prof.firstname, prof.lastname], " ")
  end


  def show_class(id) do
     get_class(id) # looks like a changeset
     |> Class.changeset()
  end

  def get_class_by(attrs) do
    @repo.get_by(Class, attrs)
  end


  def update_class(%Auction.Class{} = class, updates) do
    class
      |> Auction.Class.changeset(updates)
      |> @repo.update()
  end

  def edit_class(id) do
    get_class(id)
    |> Class.changeset()
  end

  def delete_class(%Auction.Class{} = class), do: @repo.delete(class)

  def show_classes(id) do
    Auction.get_user(id)
    |> @repo.preload(:classes)
  end

  def get_classes(id) do #Get all students for one user - alternate method
  query = from(Class, where: [user_id: ^id], select: [:firstname, :grade, :birthday, :updated_at, :user_id])
    Repo.all(query)  #brings back list of structs
  end

  def testlist([]), do: []
  def testlist([ [title, section, period, fee, semester, name, helper1, helper2] | tail])  do
      [ [title, section, period, fee, semester, name, helper1, helper2]  | testlist(tail) ]
      |> IO.inspect()
      IO.puts("REcursion")
  end
      # [ [title, section, period, fee, semester, name, helper1, helper2] tail] | testlist(tail) ]
 # end
  def testlist([ _ | tail]), do: testlist(tail)

end
