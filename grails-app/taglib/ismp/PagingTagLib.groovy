package ismp

class PagingTagLib {
    def pageNavi = {attrs->
        def offset = params.int('offset') ?: 0
        def max = params.int('max')?:10
        def total = attrs.int('total') ?: 0
        int curpage = (offset / max) + 1
        int totalpages = Math.round(Math.ceil(total / max))

        if(totalpages > 1)
        {
            def html="""

                <ul>
                    <li>共${totalpages}页 （${total}条记录）</li>

            """
            out << html
            if(curpage == 1){
//                out << "<li><img src=\"${resource(dir:'images',file:'fy_nofirst.gif')}\" width=\"20\" height=\"20\"></li>\n"
//                out << "<li><img src=\"${resource(dir:'images',file:'fy_nopre.gif')}\" width=\"20\" height=\"20\"></li>\n"
                out << "<li>第 ${curpage} 页</li>\n"
                out << "<li><a href=\"javascript:pageJS(${curpage+1});\" class='fyxz'>4</a></li>\n"
                out << "<li><a href=\"javascript:pageJS(${totalpages});\" class='fyxz'>8</a></li>\n"
            } else if(curpage == totalpages){
                out << "<li><a href=\"javascript:pageJS(1);\" class='fyxz'>7</a></li>\n"
                out << "<li><a href=\"javascript:pageJS(${curpage-1});\" class='fyxz'>3</a></li>\n"
                out << "<li>第 ${curpage} 页</li>\n"
//                out << "<li><img src=\"${resource(dir:'images',file:'fy_nonext.gif')}\" width=\"20\" height=\"20\"></li>\n"
//                out << "<li><img src=\"${resource(dir:'images',file:'fy_nolast.gif')}\" width=\"20\" height=\"20\"></li>\n"
            }else{
                out << "<li><a href=\"javascript:pageJS(1);\" class='fyxz'>7</a>\n</li>"
                out << "<li><a href=\"javascript:pageJS(${curpage-1});\" class='fyxz'>3</a></li>\n"
                out << "<li>第 ${curpage} 页</li>\n"
                out << "<li><a href=\"javascript:pageJS(${curpage+1});\" class='fyxz'>4</a></li>\n"
                out << "<li><a href=\"javascript:pageJS(${totalpages});\" class='fyxz'>8</a></li>\n"
            }
            html = """
                    <li>跳转到第</li>
                    <li>
                    <input type="hidden" name="offset" id="offset" value="">
                    <select id="page" name="page" onchange="turnpage(this.value)">
          """
            out << html
            for(int i=1;i<=totalpages;i++)
            {
                if(i==curpage)  out << "<option value='${i}' selected>${i}</option>\n"
                else out << "<option value='${i}'>${i}</option>\n"
            }
            html="""
                      </select>
                    </li>
                    <li>页</li>
					<li>显示</li>
					<li><select name="max" id="max" value="${max}" onchange="turnpage(this.value)">
					  """
             out << html
                    for(int j=10;j<=50;j=j+10)
            {
                if(j==max)  out << "<option value='${j}' selected>${j}</option>\n"
                else out << "<option value='${j}'>${j}</option>\n"
            }
               html="""
				      </select>
					<li>条</li>
                </ul>

                """
            out << html
	    }else{
            def html = """

                <ul>
                    <li>共${totalpages}页 （${total}条记录）</li>
                    <li class='fyxz'>7</li>
                    <li class='fyxz'>3</li>
                    <li>第 ${curpage} 页</li>
                    <li class='fyxz'>4</li>
                    <li class='fyxz'>8</li>
                    <li>跳转到第</li>
                    <li>
                    <input type="hidden" name="offset" id="offset" value="">
                    <input type="hidden" name="max" id="max" value="${max}">
                        <select id="page" name="page">
                          <option>1</option>
                        </select>
                    </li>
                    <li>页</li>
                </ul>

            """
            out << html
        }
    }
}
