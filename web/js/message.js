/*function tips_pop(){
 var MsgPop=document.getElementById("winpop");
 var popH=parseInt(MsgPop.style.height);//将对象的高度转化为数字
 if (popH==0){
 MsgPop.style.display="block";//显示隐藏的窗口
 show=setInterval("changeH('up')",2);
 }
 else { 
 hide=setInterval("changeH('down')",2);
 }
 }*/
function tips_up(id) {
    show = setInterval("changeH('" + id + "','up')", 2);
}
function tips_down(id) {
    hide = setInterval("changeH('" + id + "','down')", 2);
}
function changeH(id, str) {
    var pHeight = 0;
    if (id == "winpop") {
        pHeight = 138;
        type = "margin-bottom";
    }
    else if (id == "sucpop") {
        pHeight = 60;
        type = "margin-top";
    }
    var popH = parseInt($("#" + id).css(type));
    if (str == "up") {
        if (popH <= pHeight) {
            $("#" + id).css(type, popH + 4);
        }
        else {
            clearInterval(show);
        }
    }
    if (str == "down") {
        if (popH >= 4) {
            $("#" + id).css(type, popH - 4);
        }
        else {
            clearInterval(hide);
            $("#" + id).hide();
        }
    }
}
/*function changeH(id,str) {
 var pHeight = 0;
 if(id=="winpop")
 pHeight = 100;
 else if(id=="sucpop")
 pHeight = 60;
 var MsgPop=document.getElementById(id);
 var popH=parseInt(MsgPop.style.height);
 if(str=="up"){
 if (popH<=pHeight){
 MsgPop.style.height=(popH+4).toString()+"px";
 }
 else{  
 clearInterval(show);
 }
 }
 if(str=="down"){ 
 if (popH>=4){  
 MsgPop.style.height=(popH-4).toString()+"px";
 }
 else{ 
 clearInterval(hide);   
 MsgPop.style.display="none";  //隐藏DIV
 }
 }
 }*/