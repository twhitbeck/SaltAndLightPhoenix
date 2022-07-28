<h1><%=# @profile.lastname %></h1>

<h1>show student</h1>
<% IO.puts("show template") %>
 <! –– assigns - [:conn, :current_user, :student] ––> 
 <! –– from Map.keys(assigns) ––> 

<ul> 
 <li><strong>firstname:</strong> <%= @student.firstname %></li>
</ul>

<% IO.puts("show for students") %>
<% IO.inspect(Routes.student_path(@conn,:show)) %>
<% IO.puts("inspected") %>
<%= render("form.html", student: @student, action: Routes.student_path(@conn,:show), conn: @conn) %>
