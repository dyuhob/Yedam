<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
.uploadResult {
	width:100%;
	background-color: gray;	
}

.uploadResult ul{
	display:flex;
	flex-flow: row;
	justify-content: center;
	align-items: center;
}

.uploadResult ul li{
	list-style: none;
	padding : 10px;
	align-content: center;
	text-align: center;
}

.uploadResult ul li img{
	width: 100px;
}

.uploadResult ul li span{
	color: white;
}

.bigPictureWrapper {
	position: absolute;
	display: none;
	justify-content: center;
	align-items: center;
	top: 0%;
	width: 100%;
	height: 100%;
	background-color: grey;
	z-index: 100;
	background:rgba(255, 255, 255, 0.5);
}

.bigPicture {
	position: relative;
	display: flex;
	justify-content: center;
	align-items: center;
}

.bigPicture img {
	width: 600px;
}
</style>
</head>
<body>
	<h2>Upload with Ajax</h2>
	<div class="uploadDiv">
		<input type="file" name="uploadFile" multiple>
	</div>
	<button id="uploadBtn">Upload</button>
	
	<div class="uploadResult">
		<ul></ul>
	</div>
	<div class="bigPictureWrapper">
		<div class="bigPicture">

		</div>
	</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.3/jquery.min.js"></script>

<script>

	function showImage(fileCallPath){
		console.log(fileCallPath);

		$(".bigPictureWrapper").css("display", "flex").show();

		$('.bigPicture').html("<img src='/display?fileName=" + encodeURI(fileCallPath)+ "'>")
		.animate({width: '100%', heigth: '100%'}, 1000);
	}

	$(document).ready(function(){
		// 파일크기 지정, 확장자 제한.
		var regex = new RegExp("(.*?)\.(exe|sh|zip|alz)$");
		var maxSize = 5 * 1024 * 1023; 
		
		function checkExtension(fileName,fileSize){
			if(fileSize > maxSize){
				alert('파일 사이즈 초과');
				return false;
			}
			if(regex.test(fileName)){
				alert('해당 종류의 파일은 전송할 수 없습니다.');
				return false;
			}
			return true;
		}
		
		var cloneObj = $(".uploadDiv").clone();
		
		$('#uploadBtn').on('click', function(e){
		
		var formData = new FormData();
		var inputFile = $('input[name="uploadFile"]');
		var files = inputFile[0].files;
		
		for(var i=0; i<files.length; i++){
			if(!checkExtension(files[i].name, files[i].size)){
				return false;
			}
			
			formData.append("uploadFile", files[i]);
		}
		//Ajax 활용 파일전송
		$.ajax({
			url: '/uploadAjaxAction',
			processData: false,
			contentType: false,
			data: formData, // file전송 : multipart/form-data, key-val&key=val
			type: 'POST',
			dataType: 'json',
			success: function(result){
				console.log(result);
				
				showUploadedFile(result);
				
				$(".uploadDiv").html(cloneObj.html());
				
			},
			error: function(err){
				console.log(err);
			}
					
		})

		$('.bigPictureWrapper').on('click', function(e){
			$('.bigPicture').animate({width: '0%', heigth: '0%'}, 1000);
			setTimeout(() => {
				$(this).hide();
			}, 1000);
		})
		
		$(".uploadResult").on('click', 'span', function(e){

			var targetFile = $(this).data("file");
			var type = $(this).data("type");
			console.log(targetFile);

			$(this).parent().empty();
				
			$.ajax({
				url: '/deleteFile',
				data: {fileName: targetFile, type:type},
				dataType: 'text',
				type: 'POST',
				success: function(result){
					alert(result);
					
					
					//$('div.uploadResult ul li').html("");
				}

			})
		})

		})
		
		var uploadResult = $('.uploadResult ul');
		
		function showUploadedFile(uploadResultArr){
			var str = "";
			
			$(uploadResultArr).each(function(i, obj){
			
			if(!obj.image){
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/" + obj.uuid + "_" + obj.fileName);

				var fileLink = fileCallPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li><div><a href='/download?fileName=" + fileCallPath + "'>" + "<img src='/resources/img/attach.png'>" + obj.fileName + "</a>" 
					+ "<span data-file=\'" +  fileCallPath + "\' data-type='image'> x </span>" + "</div></li>";
			} else {
				//str += "<li>" + obj.fileName + "</li>";
				
				var fileCallPath = encodeURIComponent( obj.uploadPath + "/s_" + obj.uuid + "_" + obj.fileName);
				
				var originPath = obj.uploadPath + "\\" + obj.uuid + "_" + obj.fileName;
				originPath = originPath.replace(new RegExp(/\\/g), "/");
				
				str += "<li><a href=\"javascript:showImage(\'" + originPath + "\')\"><img src='/display?fileName=" + fileCallPath + "'></a>" + 
					"<span data-file=\'" + fileCallPath + "\' data-type='image'> x </span>" + "</li>";
			}
				
			});
			
			uploadResult.append(str);
		}
	
	});
</script>

</body>
</html>