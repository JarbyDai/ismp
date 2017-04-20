
//查看、预览
$(function(){
    "use strict";
    function viewAnnex(link,callback){
        var _link = $(link);
        _link.live('click',function(event){
            var _src = $(this).attr('data-src');
            var _offLeft = ($(this).offset().left) / 3 - 50 + 'px',
                _offTop = $(this).offset().top - 600 + 'px';
            // 移除之前插入的图片
            $('.viewBox').remove();
            // 插入图片
            createViewBox(_src,_offTop,_offLeft);
            // console.log(_imgWidth);
            // 异步，执行回调函数，执行图片放大，(只有图片插入之后才可以点击查看放大图片)
            callback();
            if (event.preventDefault) {
                event.preventDefault(); //支持DOM标准的浏览器
            } else {
                event.returnValue = false; //IE
            }
        });
    }
    viewAnnex('.view-link',magnifyImg);
// 创建预览容器
    function createViewBox(src,top,left){
        var viewBox = $('<div class="viewBox">'+
            '<img src="' + src +'" class="magnify"/>' +
            '</div>');
        viewBox.css({"top":top,"left":left});
        $('.patten-container').append(viewBox);
        showViewBox();
    }
//    show viewBox
    function showViewBox(){
        $('.viewBox').fadeIn(600);
    }
    $(function(){
        // 点击空白隐藏图片
        $(document).bind("click",function(event){
            var target = $(event.target);
            if (target.closest('.viewBox,.view-link').length === 0 ) {
                $('.viewBox').fadeOut(400);
            }
        });

    });
// 查看大图
    function magnifyImg(){
        // 仅能放大一次
        $('.magnify').one("click",function(){
            var imgWidth = $(this).width(),
                imgHeight = $(this).height();
//            var src = $(this).attr('src');
//            console.log(src);
//            图片放大法
            if(imgWidth < 800){
                $(this).animate({
                    width:imgWidth * 2,
                    height:imgHeight * 2
                });
            }
//            替换路径
//            changImgSrc($(this),"small","big");
        });
    }
    function changImgSrc(ele,oldSrc,newSrc){
        $(ele).each(function(){
            var newSrcs = $(this).attr("src").replace(oldSrc,newSrc);
            $(this).css({'opacity':'0'});
            $(this).attr("src",newSrcs);
            $(this).css({'opacity':''});
        })
    }
//    锚点跳转
    function grtAnchor(anchorID){
        var $target= $(anchorID).offset().top;
        $('body').animate({scrollTop:$target}, 600);
    }
    function goToAnchor(link){
        var $link = $(link);
        $link.on('click',function(){
            var $href = $(this).attr('href').split('#')[1];
            grtAnchor('#' + $href);
        });
    }
    goToAnchor('.anchor');
    /*
     * params:eleID，需要插入数据的表格id
     * identify：获取的数据标识，1为基本资料，2为填写资料，3为附件
     * */

     var jsonUrl1 = "/js/guide/json/general.json";
     var jsonUrl2 = "/js/guide/json/bulk.json";
     var imgUrl = "/images/guide/small/";
     var downUrl = "/guide/";
     function getJsonRemarks(ele,identify,jsonUrl){
        $.ajax({
            type: "GET",
            url: contextPath + jsonUrl,
            dataType:"json",
            success: function(data){
                var eleID = $(ele);
//                解析数组
                if(identify == '1'){
                    $.each(data.remark1, function(key,value){
                        eleID.append(
                            "<li>"+ value+"</li>"
                        )
                    })
                }
                if(identify == '2'){
                    $.each(data.remark2, function(key,value){
                        eleID.append(
                            "<li>"+ value+"</li>"
                        )
                    })
                }
                if(identify == '3'){
                    $.each(data.remark3, function(key,value){
                        eleID.append(
                            "<li>"+ value+"</li>"
                        )
                    })
                }
            },
            error: function(XMLHttpRequest, textStatus, errorThrown){
                alert(textStatus + ':' + errorThrown +'===>>>>>获取数据失败！请联系管理员');
                console.log(textStatus + ':' + errorThrown);
            }
        });
    }
    /*
    * params:eleID，需要插入数据的表格id
    * identify：获取的数据标识，1为基本资料，2为填写资料，3为附件
    * */

//   获取json并插入数据
     function getJsonInfo(ele,identify,jsonUrl){
        $.ajax({
            type: "GET",
            url: contextPath + jsonUrl,
            dataType:"json",
            success: function(data){
//                严格模式下不允许函数内部声明的变量与形参同名：
//                var eleID = $(eleID)====>>>>>若形参名称为eleID，则此处出错
                var eleID = $(ele);
                var flag = "true";
//                解析数组
                if(identify == '1'){
                    $.each(data.basicInfo, function(key,value){
                        var className = (value.isRequired === flag) ? "required" : "optional";
                        var txt = (value.isRequired === flag)? "必须" : "可选";
//                        var imgList = eval(this.imgName);
//                        var aImg = [];
//                        if(imgList.length > 0){
//                            for(var i = 0; i < imgList.length;i++ ){
//                                aImg.push("<a href='' data-src='" + contextPath + imgUrl + imgList[i]['id'] +".jpg' class='view-link'>查看</a>") ;
//                            }
//                        }
                        eleID.append(
                            "<tr>"+
                                "<td>"+value.id +"</td>" +
                                "<td>"+value.docName +"</td>" +
                                "<td>"+value.docAmount +"</td>" +
                                "<td  class='"+ className +"'>"+ txt +"</td>" +
                                "<td>"+value.seal +"</td>" +
                                "<td><a href='' data-src='" + contextPath + imgUrl + value.imgName  +".jpg' class='view-link'>查看</a> </td>"+
                                "<td>"+value.desc +"</td>" +
                            "</tr>"
                        )
                    })
                }
                if(identify == '2'){
                    $.each(data.inputInfo, function(key,value){
                        var className = (value.isRequired === flag) ? "required" : "optional";
                        var txt = (value.isRequired === flag)? "必须" : "可选";
                        var html = (value.docUrl)? "<a target='_blank'  href='" + contextPath + downUrl +'html/'+  value.docUrl +".html'>查看</a> " : "-";
                        eleID.append(
                            "<tr>"+
                                "<td>"+value.id +"</td>" +
                                "<td>"+value.docName +"<a download='"+ value.docName + value.type +"' href='" + contextPath + downUrl + 'doc/'+  value.downUrl + value.type +"'>下载</a> </td>" +
                                "<td>"+value.docAmount +"</td>" +
                                "<td  class='"+ className +"'>"+ txt +"</td>" +
                                "<td>"+value.seal +"</td>" +
                                "<td>"+ html + "</td>"+
                                "<td>"+value.desc +"</td>"+
                            "</tr>"
                        )
                    })
                }
                if(identify == '3'){
                    $.each(data.annexInfo, function(key,value){
                        eleID.append(
                            "<tr>"+
                                "<td>"+value.id +"</td>" +
                                "<td>"+value.docName +"<a download='"+ value.docName + value.type +"' href='" + contextPath +downUrl + 'doc/'+  value.downUrl + value.type +"'>下载</a> </td>" +
                                "<td>"+value.docAmount +"</td>" +
                                "<td>"+value.seal +"</td>" +
                                "<td><a target='_blank'  href='" + contextPath + downUrl +'doc/'+  value.downUrl +".pdf'>预览</a>  </td>"+
                                "<td>"+value.desc +"</td>" +
                            "</tr>"
                        )
                    })
                }
            }
        });
    }

    // 普通商户插入数据
    getJsonInfo('#basic-info','1',jsonUrl1);
    getJsonInfo('#input-info','2',jsonUrl1);
    getJsonInfo('#annex-info','3',jsonUrl1);
    // 大宗商户
    getJsonInfo('#bulk-basic-info','1',jsonUrl2);
    getJsonInfo('#bulk-input-info','2',jsonUrl2);
    getJsonInfo('#bulk-annex-info','3',jsonUrl2);
    // 插入备注
    getJsonRemarks('#remark-1','1',jsonUrl1);
    getJsonRemarks('#remark-2','2',jsonUrl1);
    getJsonRemarks('#remark-3','3',jsonUrl1);
    // 大宗商户备注
    getJsonRemarks('#bulk-remark-1','1',jsonUrl2);
    getJsonRemarks('#bulk-remark-2','2',jsonUrl2);
    getJsonRemarks('#bulk-remark-3','3',jsonUrl2);
    highlightPage();
});

function highlightPage() {
    var nav = $('.link-box');
    var link = nav.find('a');
    link.each(function() {
        var url = $(this).attr('href');
        var currUrl = window.location.href;
        if (currUrl.indexOf(url) != -1) {
            $(this).addClass('active');
        }
    });
}
