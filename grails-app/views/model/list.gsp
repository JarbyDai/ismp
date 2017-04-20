<%@ page import="model.Model" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="main" />
        <g:set var="entityName" value="${message(code: 'model.label', default: 'Model')}" />
        <title>合利宝-<g:message code="default.list.label" args="[entityName]" /></title>
        <link charset="utf-8" rel="stylesheet" href="${resource(dir: 'css/flick', file: 'jquery-ui-1.8.7.custom.css')}" media="all"/>
        <link rel="stylesheet" href="${resource(dir: 'css', file: 'zTreeStyle.css')}?t=${new Date().getTime()}" type="text/css">
        <script charset="utf-8" src="${resource(dir: 'js', file: 'pa.js')}"></script>
        <script charset="utf-8" src="${resource(dir: 'js', file: 'Paging.js')}"></script>
        <g:javascript library="jquery"/>
        <script charset="utf-8" src="${resource(dir: 'js', file: 'jquery-ui-1.8.7.custom.min.js')}"></script>
        <script charset="utf-8" src="${resource(dir: 'js', file: 'application.js')}"></script>
        <script src="${resource(dir: 'js', file: 'jquery.validate.min.js')}" type="text/javascript"></script>
        <script type="text/javascript" src="${resource(dir:'js',file:'jquery-ztree-2.3.min.js')}"></script>

	<script>
			function search(obj){
				if(obj){
					if($("offset"))
					$("offset").value=0;
				}
				$("#searchform").submit();
			}
	</script>

    </head>

    <body style="text-align:center;">

         <div class="main_box">
            <table width="100%" class="right_list_table" style="margin-top:20px;" id="test">
                <tr class="c1">
			<td colspan="2" scope="col" >
				<div class="xtgl_h1">
					<span class="left"><b>权限设置</b></span>
					<span style="float:right; text-align:right; margin-right:16px;"><b>角色：${rname}</b></span>
				</div>
			</td>

		</tr>
                              <tr>
                                <th scope="col">&nbsp;&nbsp;&nbsp;&nbsp;</th>
                                <th scope="col">菜单名称</th>
                              </tr>
                <tr><td></td>
                    <td><ul id="model" class="tree"></ul></td>
                </tr>
                <tr>
                    <td></td>
                    <td>
                        <a class="linkBtn" href="${createLink(controller:'model',action:'checkedAll')}/${rid}"><b>&nbsp;全部选中&nbsp;</b></a>
                        <a style="margin-left:8px" class="linkBtn" href="${createLink(controller:'model',action:'checkedAntiall')}/${rid}"><b>&nbsp;全部取消&nbsp;</b></a>
                    </td>
                </tr>
             </table>

             <div class="serch">
                 <table style="margin-left:430px;">
                     <tr>
                        <td></td>
                        <td></td>
                        <td>
                         <g:form action="saveToRole" onSubmit="return submitIds();">
                             <input type="hidden" name="result" value="${ids}" />
                             <input type="hidden" name="rid" value="${rid}" />
                             <g:submitButton class="btn mglf10" name="saveToRole" value="保存"/>
                         </g:form>
                        </td>
                        <td>
                         <input type="button" class="btn mglf10" value="返回" style="margin-left:16px" onclick="window.location='${createLink(controller:'role',action:'list')}'"/>
                        </td>
                     </tr>
                 </table>
             </div>
        </div>




<SCRIPT LANGUAGE="JavaScript">
                    <!--

            var zNodes = [${modelInstanceList}];
            /*
             树形目录参数设置
             */
            var zTree1;
            var setting = {
                checkable: true,
                isSimpleData: true,
                treeNodeKey: "point",
                treeNodeParentKey: "parentPoint",
                showLine: true,
                callback: {
                    change:zTreeOnChange
                }
            };

            $(document).ready(function(){
                refreshTree();

            });

            /*
             遍历子目录，并保存权限模块ID
             */
            function childrenModel(childrenLength, childrenNode, treeNode){
                var arr = [];
                var mid = '';
                var _length = childrenNode.length;
                for(n=0; n<_length; n++){
                    childrenTId = childrenNode.eq(n).attr("id");
                    mid = zTree1.getNodeByTId($("#"+childrenTId).attr("id")).mid

			arr.push(mid);
		}
		return arr;
	}

	/*
		选中、取消checkbox时触发次事件，并保存触发的权限模块ID
		选中时保存父模块ID，取消时保存子模块ID
	*/
	function zTreeOnChange(event, treeId, treeNode) {
		var tmp = $("input[name='result']").val();
        tmp = tmp.replace(/\[,|,\]|\s/g, '').replace(/[^\d|^,]/g, '').replace(/,,/, ',').replace(/^,|,$/g, '');

        var tId = treeNode.tId;
        var tIdNode = '';
        var model;
        var modelId = treeNode.mid;
        var modelParentArr = [];
        var modelChildrenArr = [];
        if(treeNode.checked){// 选中时
            modelParentArr.push(modelId);
			var flag = true;

            do{
               if($("#"+tId).parent().attr("class") == "tree"){
                  flag = false;
               }
               tIdNode =  $("#"+tId).parent();
               tId = tIdNode.attr("id");
               if(tId.lastIndexOf("_ul") == -1){
                  model = zTree1.getNodeByTId(tId);
                    if(model != null){
                       modelParentArr.push(model.mid);
                    }
               }
            }while(flag);
        }else {// 取消时

			modelChildrenArr.push(modelId);
			var n, m = 0;
			var childrenNode;
            var selectedNode = $("#"+treeNode.tId).children().next().next().next().children();
			var _length = selectedNode.length;

			for(n=0; n<_length; n++){
				tId = selectedNode.eq(n).attr("id");
				modelId = zTree1.getNodeByTId($("#"+tId).attr("id")).mid;
				modelChildrenArr.push(modelId);

				childrenNode = $("#"+tId).children().next().next().next().children();
				if(childrenNode.length > 0){
					var tmpChildrenArr = childrenModel(childrenNode.length, childrenNode, treeNode);
					modelChildrenArr = modelChildrenArr.concat(tmpChildrenArr);
				}
			}
        }

		tmp = ','+ tmp +',';
		var resultArr = treeNode.checked?modelParentArr:modelChildrenArr;
		var i;
		for(i=0; i<resultArr.length; i++){
			tmp = tmp.replace(new RegExp(','+resultArr[i]+',', 'g'), ',');
		}
		var tmpArr = tmp.replace(/,,|\s/g, ',').replace(/^,|,$/g, '').split(',');

		if(treeNode.checked){
			tmpArr = tmpArr.concat(resultArr);
			tmp = '[,'+tmpArr.toString()+',]';
		}else {
			tmp = '[,'+tmpArr.toString()+',]';
		}

		tmp = '[,'+tmpArr.toString()+',]';
		$("input[name='result']").val(tmp);
		$("#text").text($("input[name='result']").val());

	}

	/*
		checkbox父子联动关系
		选中时影响父，取消时影响子
	*/
    function refreshTree() {
		setting.checkType = {"Y":"p", "N":"s"};
		zTree1 = $("#model").zTree(setting, zNodes);
    }

	/*
		提交时验证是否仅仅选了第一级菜单，或没选任何权限项
		true 任选了二三级菜单
		false 仅选了一级，或未选
	*/
    function submitIds() {
		var tmpIds = $("input[name='result']").val().replace(/\[|\]|\s/g, '');

		if(tmpIds.search(/,\d+,/) == -1){
			alert("请选择操作项");
			return false;
		}

        var idsArr = tmpIds.replace(/\[,|,\]|\s/g, '').split(',');
        var i, j;
        for(i=0; i<zNodes.length; i++){
            for(j=0; j<idsArr.length; j++){
                if((zNodes[i].mid == idsArr[j]) && zNodes[i].mindex > 999){
                    return true;
                }
            }
        }

		/*
			这里出现一个或多个不存在的权限菜单ID，不影响正常的使用，最后还是放过提交了，
			但问题出现，有时间有可能的话，查查最好，目前是用个提示框显示下，我想也可以用ajax等方法提交后台
		*/
//		alert("出现一个或多个不存在的权限菜单ID，请联系管理员\n ID："+tmpIds.replace(/^,|,$/g, ''));

        return true;
    }



  //-->
  </SCRIPT>

    </body>
</html>
