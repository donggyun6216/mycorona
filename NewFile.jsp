<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.sql.*" %>


<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Kakao API Test Server</title>
</head>

<div id="map" style="width:700px;height:600px;"></div>
<p>
    <button onclick="setCenter()">지도 중심좌표 이동시키기</button> 
    <button onclick="panTo()">지도 중심좌표 부드럽게 이동시키기</button> 
    <button onclick="getInfo()">정보 표시하기</button> 
    <button onclick="getTransferInfo()">교통정보 표시하기</button> 
    <button onclick="delTransferInfo()">교통정보 표시해제하기</button> 
    <br>
    <input type="text" id="location"/>
    <button onclick="getData()">위치정보 검색하기</button> 
</p>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=e1d21be3b2b96bd5dbe554096f56ac18&libraries=services"></script>

<script>
	
	//마커를 클릭하면 장소명을 표출할 인포윈도우 입니다
	var infowindow = new kakao.maps.InfoWindow({zIndex:1});

	var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = { 
	    center: new kakao.maps.LatLng(37.55665, 126.851403) // 지도의 중심좌표
	    , level: 3 // 지도의 확대 레벨
	    //, draggable : false // 드래그 가능 여부
	    //, scrollwheel : false // 스크롤 휠 가능 여부
	    //,tileAnimation : true
	};

	var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다
	
	// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성합니다
	var mapTypeControl = new kakao.maps.MapTypeControl();
	// 지도 타입 컨트롤을 지도에 표시합니다
	map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
	

	function getData(){
		// 장소 검색 객체를 생성합니다
		var ps = new kakao.maps.services.Places();
		// 키워드로 장소를 검색합니다
		ps.keywordSearch(document.getElementById('location').value, placesSearchCB);
	}
	// 키워드 검색 완료 시 호출되는 콜백함수 입니다
	function placesSearchCB (data, status, pagination) {
	    if (status === kakao.maps.services.Status.OK) {

	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정하기위해
	        // LatLngBounds 객체에 좌표를 추가합니다
	        var bounds = new kakao.maps.LatLngBounds();

	        for (var i=0; i<data.length; i++) {
	            displayMarker(data[i]);    
	            bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));
	        }       

	        // 검색된 장소 위치를 기준으로 지도 범위를 재설정합니다
	        map.setBounds(bounds);
	    } 
	}

	// 지도에 마커를 표시하는 함수입니다
	function displayMarker(place) {
	    
	    // 마커를 생성하고 지도에 표시합니다
	    var marker = new kakao.maps.Marker({
	        map: map,
	        position: new kakao.maps.LatLng(place.y, place.x) 
	    });

	    // 마커에 클릭이벤트를 등록합니다
	    kakao.maps.event.addListener(marker, 'click', function() {
	        // 마커를 클릭하면 장소명이 인포윈도우에 표출됩니다
	        infowindow.setContent('<div style="padding:5px;font-size:12px;">' + place.place_name + '</div>');
	        infowindow.open(map, marker);
	    });
	}
	
	
	
	
	function setCenter() {            
		// 이동할 위도 경도 위치를 생성합니다 
		var moveLatLon = new kakao.maps.LatLng(37.584452, 126.885882);
		
		// 지도 중심을 이동 시킵니다
		map.setCenter(moveLatLon);
	}
	
	function panTo() {
		// 이동할 위도 경도 위치를 생성합니다 
		var moveLatLon = new kakao.maps.LatLng(37.581006, 126.890212);
		
		// 지도 중심을 부드럽게 이동시킵니다
		// 만약 이동할 거리가 지도 화면보다 크면 부드러운 효과 없이 이동합니다
		map.panTo(moveLatLon);            
	}        
	function getInfo() {
	    // 지도의 현재 중심좌표를 얻어옵니다 
	    var center = map.getCenter(); 
	    
	    // 지도의 현재 레벨을 얻어옵니다
	    var level = map.getLevel();
	    
	    // 지도타입을 얻어옵니다
	    var mapTypeId = map.getMapTypeId(); 
	    
	    // 지도의 현재 영역을 얻어옵니다 
	    var bounds = map.getBounds();
	    
	    // 영역의 남서쪽 좌표를 얻어옵니다 
	    var swLatLng = bounds.getSouthWest(); 
	    
	    // 영역의 북동쪽 좌표를 얻어옵니다 
	    var neLatLng = bounds.getNorthEast(); 
	    
	    // 영역정보를 문자열로 얻어옵니다. ((남,서), (북,동)) 형식입니다
	    var boundsStr = bounds.toString();
	    
	    
	    var message = '지도 중심좌표는 위도 ' + center.getLat() + ', <br>';
	    message += '경도 ' + center.getLng() + ' 이고 <br>';
	    message += '지도 레벨은 ' + level + ' 입니다 <br> <br>';
	    message += '지도 타입은 ' + mapTypeId + ' 이고 <br> ';
	    message += '지도의 남서쪽 좌표는 ' + swLatLng.getLat() + ', ' + swLatLng.getLng() + ' 이고 <br>';
	    message += '북동쪽 좌표는 ' + neLatLng.getLat() + ', ' + neLatLng.getLng() + ' 입니다';
	    
	    // 개발자도구를 통해 직접 message 내용을 확인해 보세요.
	    alert(message);
	}
	function getTransferInfo(){
		// 지도에 교통정보를 표시하도록 지도타입을 추가합니다
		map.addOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC); 
	}
	function delTransferInfo(){
		// 아래 코드는 위에서 추가한 교통정보 지도타입을 제거합니다
		 map.removeOverlayMapTypeId(kakao.maps.MapTypeId.TRAFFIC);
	}
</script>
<body>


	
</body>
</html>