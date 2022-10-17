<%# require IEx; IEx.pry() %>
<%# assigns ClassTitle.description - plus classes - a list of class info (map) %>
<!--Available assigns: [:classes, :conn, :current_user, :id, :title] -->
<html>
<body>
<head>
<p id="output"></p>
<style>
.table-layout {
    text-align: center;
    border: 1px solid black;
    border-collapse: collapse;
    font-family:"Trebuchet MS";
    margin: 0 auto 0;
}
.table-layout td, .table-layout th {
    border: 1px solid grey;
    padding: 5px 5px 0;
}
.table-layout td {
    text-align: left;
}
.selected {
    color: red;
}
    border: 1px solid grey;
    padding: 5px 5px 0;
}
.table-layout td {
    text-align: left;
}
.selected {
    color: red;
}


</style>

<html>
<body>
<form id="contact-form" action="https://reqbin.com/echo/post/form">
<h2> templates class show </h2>



<SCRIPT LANGUAGE="JavaScript">
function testResults (form) {
    var TestVar = form.classbox.value;
    alert ("You typed: " + TestVar);
}
</SCRIPT>

<form id="person-form">
  <div>
    <label for="first-name">First Name</label>
    <input type="text" id="first-name" name="first-name" required>
  </div>

  <div>
    <label for="last-name">Last Name</label>
    <input type="text" id="last-name" name="last-name" required>
  </div>

  <div>
    <label for="email">Email</label>
    <input type="email" id="email" name="email" required>
  </div>

  <button>Submit</button>
</form>

<form name="regform" ACTION="" METHOD="POST">
  <input type="text"   name = "studentbox"  class="required" id="studentid" >
  <input type="text"   name = "classbox"    class="required" id="classid" >
  <input type="text"   name = "semesterbox" class="required" id="semester">
  <input type="button" name="button" Value="Click reg" onClick="testResults(this.form)">
</form>



<button disabled id ="saveButton" onclick = "regFunction()">Save</button>
<button onclick = "cancelFunction()">Cancel</button>

<table id="classTable" class="table-layout">
    <tr  onclick="(this)">
      <th>ClassID </th>
      <th>Class title</th>
      <th>Section</th>
      <th>Period</th>
      <th>Fee</th>
      <th>Semester</th>
      <th>Teacher</th>
      <th>Helper1</th>
      <th>Helper2</th>
    </tr>

 <tr>
  <%= for {class, i} <- Enum.with_index(@classes,0) do%>
    <%= for {item, k} <- Enum.with_index(class,0) do%>
     <td> &nbsp;  <%= item %> </td>
      <% end %>
    </tr>
    <% end %>
  </table>

<%= link "Student Page!", to: Routes.student_path(@conn, :index) %>
<script>
   function regFunction() {
    studentid  = localStorage.getItem("studentID");
    classid    = localStorage.getItem("classID");
    semesterid = localStorage.getItem("semesterID"); // @fields  [:student_id, :class_id, :semester]

    //<%=# render(conn, "Registration.create.html", student_id: studentid, classid: classid, semester: semesterid) %>;
//to: Routes.profile_path(@conn, :edit) %>
//class_student_registration_path(@conn, :create)

    alert("map");
    //studentid =  window["studentID"];

    //document.getElementById('studentid').setAttribute('value', studentid);
    //document.getElementById('classid').setAttribute('value', classid);
    //document.getElementById('semester').setAttribute('value', semesterid);
   }
</script>

<script>
  function cancelFunction() {
     close();
}

</script>

<script>
highlight_row();

function highlight_row() {
    var table = document.getElementById('classTable');
    var cells = table.getElementsByTagName('td');
    for (var i = 0; i < cells.length; i++) {
        // Take each cell
        var cell = cells[i];
        // do something on onclick event for cell
        cell.onclick = function () {
            // Get the row id where the cell exists
            var rowId = this.parentNode.rowIndex;
            var rowsNotSelected = table.getElementsByTagName('tr');
            for (var row = 0; row < rowsNotSelected.length; row++) {
                rowsNotSelected[row].style.backgroundColor = "";
                rowsNotSelected[row].classList.remove('selected');
            }
            var rowSelected = table.getElementsByTagName('tr')[rowId];
            rowSelected.style.backgroundColor = "yellow";
            rowSelected.className += " selected";

            var titleID = rowSelected.cells[0].innerHTML;
            var semester = rowSelected.cells[5].innerHTML;
            var sem      = semester.replace( /^\D+/g, '');
            var classnum = titleID.replace( /^\D+/g, ''); //remove leading non digits

            localStorage.setItem("semesterID", sem);
            localStorage.setItem("classID",    classnum);
            studentid  = localStorage.getItem("studentID")
            classid    = localStorage.getItem("classID");
            semesterid = localStorage.getItem("semesterID");
            //studentid =  window["studentID"];

            document.getElementById('studentid').setAttribute('value', studentid);
            document.getElementById('classid').setAttribute('value', classid);
            document.getElementById('semester').setAttribute('value', semesterid);
            enableSubmit(); //enable the save button if inputs are valid
         }
    }
}
</script>


</body>



<script>
    //check that all 3 hidden inputs are valid
    function enableSubmit(){
      let inputs = document.getElementsByClassName('required');
      //let btn = document.querySelector('input[type="submit"]');
      var btn = document.getElementById("saveButton");
      let isValid = true;
      for (var i = 0; i < inputs.length; i++){
      let changedInput = inputs[i];
      if (changedInput.value.trim() === "" || changedInput.value === null){
        isValid = false;
      break;
      }
    }
    btn.disabled = !isValid;
  }
</script>
</body>
</html>
