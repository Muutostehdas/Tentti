<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<link rel="stylesheet" type="text/css" href="css/main.css">
<title>listaa veneet</title>
</head>
<body>
	<table id="listaus">
		<thead>
			<tr>
				<th colspan="6" class="oikealle"><span id="uusiVene">Lis??
						uusi vene</span></th>
			</tr>
			<tr>
				<th class="oikealle">Hakusana:</th>
				<th colspan="4"><input type="text" id="hakusana"></th>
				<th><input type="button" value="hae" id="hakunappi"></th>
			</tr>
			<tr>
				<th>Veneen nimi</th>
				<th>Merkki ja malli</th>
				<th>Pituus</th>
				<th>Leveys</th>
				<th>Hinta</th>
				<th>&nbsp;</th>
			</tr>
		</thead>
		<tbody>
		</tbody>
	</table>
	<script>
		$(document).ready(function() {
			$("#uusiVene").click(function() {
				document.location = "lisaavene.jsp";
			});

			haeVeneet();
			$("#hakunappi").click(function() {
				haeVeneet();
			});
			$(document.body).on("keydown", function(event) {
				if (event.which == 13) { //Enteri? painettu, ajetaan haku
					haeVeneet();
				}
			});
			$("#hakusana").focus();//vied??n kursori hakusana-kentt??n sivun latauksen yhteydess?
		});

		//Funktio tietojen hakemista varten
		//GET   /asiakkaat/{hakusana}
		function haeVeneet() {
			$("#listaus tbody").empty();
			$.ajax({
				url : "veneet/" + $("#hakusana").val(),
				type : "GET",
				dataType : "json",
				success : function(result) {//Funktio palauttaa tiedot json-objektina		
					$.each(result.veneet, function(i, field) {
						var htmlStr;
						htmlStr += "<tr id='rivi_"+field.tunnus +"'>";
						htmlStr += "<td>" + field.nimi + "</td>";
						htmlStr += "<td>" + field.merkkimalli + "</td>";
						htmlStr += "<td>" + field.pituus + "</td>";
						htmlStr += "<td>" + field.leveys + "</td>";
						htmlStr += "<td>" + field.hinta + "</td>";
						htmlStr += "<td><a href='muutavene.jsp?tunnus="
								+ field.tunnus + "'>Muuta</a>&nbsp;";
						htmlStr += "<span class='poista' onclick=poista("
								+ field.tunnus + ",'"
								+ field.nimi.replace(" ", "&nbsp;") + "','"
								+ field.merkkimalli.replace(" ", "&nbsp;")
								+ "')>Poista</span></td>"; //Muodostetaan linkki 
						htmlStr += "</tr>";
						$("#listaus tbody").append(htmlStr);
					});
				}
			});

		}

		//Funktio tietojen poistamista varten. Kutsutaan backin DELETE-metodia ja v?litet??n poistettavan tiedon id. 
		//DELETE /veneet/id
		function poista(tunnus, nimi, merkkimalli) {
			if (confirm("Poista vene " + nimi + " , " + merkkimalli + "?")) {
				$
						.ajax({
							url : "veneet/" + tunnus,
							type : "DELETE",
							dataType : "json",
							success : function(result) { //result on joko {"response:1"} tai {"response:0"}
								if (result.response == 0) {
									$("#ilmo").html(
											"Veneen poisto ep?onnistui.");
								} else if (result.response == 1) {
									$("#rivi_" + tunnus).css(
											"background-color", "red"); //V?rj?t??n poistetun asiakkaan rivi
									alert("Veneen " + nimi + " " + merkkimalli
											+ " poisto onnistui.");
									haeVeneet();
								}
							}
						});
			}
		}
	</script>
</body>
</html>