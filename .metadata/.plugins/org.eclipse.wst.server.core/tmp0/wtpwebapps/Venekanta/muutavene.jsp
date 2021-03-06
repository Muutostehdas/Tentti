<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script src="scripts/main.js"></script>
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script
	src="http://ajax.aspnetcdn.com/ajax/jquery.validate/1.15.0/jquery.validate.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>muuta vene</title>
</head>
<body>
	<form id="tiedot">
		<table>
			<thead>
				<tr>
					<th colspan="7" class="oikealle"><span id="takaisin">Takaisin
							listaukseen</span></th>
				</tr>
				<tr>
					<th>Nimi</th>
					<th>Merkki ja Malli</th>
					<th>Pituus</th>
					<th>Leveys</th>
					<th>Hinta</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td><input type="text" name="nimi" id="nimi"></td>
					<td><input type="text" name="merkkimalli" id="merkkimalli"></td>
					<td><input type="text" name="pituus" id="pituus"></td>
					<td><input type="text" name="leveys" id="leveys"></td>
					<td><input type="text" name="hinta" id="hinta"></td>
					<td><input type="submit" id="tallenna" value="Hyv?ksy"></td>
				</tr>
			</tbody>
		</table>
		<input type="hidden" name="tunnus" id="tunnus">
	</form>
	<span id="ilmo"></span>
</body>
<script>
	$(document).ready(function() {
		$("#takaisin").click(function() {
			document.location = "listaaveneet.jsp";
		});
		//Haetaan muutettavan asiakkaant tiedot. Kutsutaan backin GET-metodia ja v?litet??n kutsun mukana muutettavan tiedon id
		//GET /veneet/haeyksi/tunnus
		var tunnus = requestURLParam("tunnus"); //Funktio l?ytyy scripts/main.js 	
		$.ajax({
			url : "veneet/haeyksi/" + tunnus,
			type : "GET",
			dataType : "json",
			success : function(result) {
				$("#nimi").val(result.nimi);
				$("#merkkimalli").val(result.merkkimalli);
				$("#pituus").val(result.pituus);
				$("#leveys").val(result.leveys);
				$("#hinta").val(result.hinta);
				$("#tunnus").val(result.tunnus);
			}
		});

		$("#tiedot").validate({
			rules : {
				nimi : {
					required : true
				},
				merkkimalli : {
					required : true
				},
				pituus : {
					required : true,
					number : true
				},
				leveys : {
					required : true,
					number : true
				},
				hinta : {
					required : true,
					number : true
				}
			},
			messages : {
				nimi : {
					required : "Anna nimi"
				},
				merkkimalli : {
					required : "Anna merkki ja malli"
				},
				pituus : {
					required : "Anna pituus kokonais- tai desimaalilukuna",
					number : "K?yt? desimaalierottimena pistett? (.)"
				},
				leveys : {
					required : "Anna leveys kokonais- tai desimaalilukuna",
					number : "K?yt? desimaalierottimena pistett? (.)"
				},
				hinta : {
					required : "Anna hinta",
					number : "Vain kokonaisluku kelpaa"
				}
			},
			submitHandler : function(form) {
				paivitaTiedot();
			}
		});
	});
	//funktio tietojen p?ivitt?mist? varten. Kutsutaan backin PUT-metodia ja v?litet??n kutsun mukana uudet tiedot json-stringin?.
	//PUT /veneet/
	function paivitaTiedot() {
		var formJsonStr = formDataJsonStr($("#tiedot").serializeArray()); //muutetaan lomakkeen tiedot json-stringiksi
		$.ajax({
			url : "veneet",
			data : formJsonStr,
			type : "PUT",
			dataType : "json",
			success : function(result) { //result on joko {"response:1"} tai {"response:0"}       
				if (result.response == 0) {
					$("#ilmo").html("Asiakkaan p?ivitt?minen ep?onnistui.");
				} else if (result.response == 1) {
					$("#ilmo").html("Asiakkaan p?ivitt?minen onnistui.");
					$("#nimi, #merkkimalli, #pituus, #leveys, #hinta").val("");
				}
			}
		});
	}
</script>
</html>