<%--
  User: zhangnan
  Date: 12-8-26
  Time: 下午4:32
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:set var="ctx" value="${pageContext.request.contextPath}"/>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>文件管理</title>
    <link rel="stylesheet" href="${ctx}/static/js/filetree/jquery.treeview.css"/>
    <link rel="stylesheet" href="${ctx}/static/js/fileupload/jquery.fileupload-ui.css"/>
    <link rel="stylesheet" href="${ctx}/static/js/fancyBox/jquery.fancybox.css?v=2.0.5" type="text/css" media="screen"/>
    <link rel="stylesheet" href="${ctx}/static/js/fancyBox/helpers/jquery.fancybox-buttons.css?v=2.0.5" type="text/css" media="screen"/>
    <link rel="stylesheet" href="${ctx}/static/js/fancyBox/helpers/jquery.fancybox-thumbs.css?v=2.0.5" type="text/css" media="screen"/>
</head>
<body>
<div class="page">
<div class="page-header">
    <h2>文件管理
        <small>欢迎进入文件管理</small>
    </h2>
</div>
<div class="row">
    <!-- 目录树 -->
    <div class="span3">
        <div class="well" id="parent">
            <ul id="browser" class="filetree treeview">
                <c:forEach items="${nodes}" var="node" begin="0" step="1">
                    <li class="closed"><span id="${node.id}"
                                             class="folder<c:if test="${empty node.nodeList}"> leafnode</c:if>">${node.name}</span>
                        <c:if test="${not empty node.nodeList}">
                            <ul>
                                <c:forEach items="${node.nodeList}" var="node2" begin="0" step="1">
                                    <li class="expandable"><span id="${node2.id}"
                                                                 class="folder<c:if test="${empty node2.nodeList}"> leafnode</c:if>">${node2.name}</span>
                                        <c:if test="${not empty node2.nodeList}">
                                            <ul>
                                                <c:forEach items="${node2.nodeList}" var="node3" begin="0" step="1">
                                                    <li class="closed expandable"><span id="${node3.id}"
                                                                                        class="folder<c:if test="${empty node3.nodeList}"> leafnode</c:if>">${node3.name}</span>
                                                    </li>
                                                </c:forEach>
                                            </ul>
                                        </c:if>
                                    </li>
                                </c:forEach>
                            </ul>
                        </c:if>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
    <!-- 文件列表 -->
    <div class="span9">
        <div class="well">
            <div id="file-list" class="hide">
                <!-- 文件列表 -->
                <table class="table table-hover">
                    <thead>
                    <tr>
                        <th><label class="checkbox"><input id="checkedAll" type="checkbox" value=""></label></th>
                        <th>文件名</th>
                        <th>类型</th>
                        <th>大小</th>
                        <th>日期</th>
                        <th>MD5</th>
                        <th>常用操作</th>
                        <th>管理操作</th>
                    </tr>
                    </thead>
                    <tbody id="file-items"></tbody>
                </table>
            </div>
            <!-- 分页 -->
            <div class="pagination pagination-right">
                <ul id="pagination">
                </ul>
            </div>
            <!-- 文件上传 -->
            <form id="fileupload" action="${ctx}/file/create" method="post" enctype="multipart/form-data">
                <div class="btn-group">
                    <span class="btn btn-success fileinput-button" style="margin-right:0px;">
                    <span>选择文件...</span>
                    <input type="file" name="file[]" multiple="multiple" />
                    </span>
                        <button class="btn start">开始上传</button>
                        <button class="btn cancel">取消上传</button>
                    </div>


                <!-- The global progress information -->
                <div class="span5 fileupload-progress fade">
                    <!-- The global progress bar -->
                    <div id="progress" class="progress progress-success progress-striped active" role="progressbar"
                         aria-valuemin="0" aria-valuemax="100">
                        <div class="bar" style="width:0%;"></div>
                    </div>
                    <!-- The extended global progress information -->
                    <div class="progress-extended">&nbsp;</div>
                </div>

                <!-- The loading indicator is shown during file processing -->
                <div class="fileupload-loading"></div>
                <br>
                <!-- The table listing the files available for upload/download -->
                <table role="presentation" class="table table-striped">
                    <tbody class="files" data-toggle="modal-gallery" data-target="#modal-gallery"></tbody>
                </table>
            </form>
            <!-- modal-gallery is the modal dialog used for the image gallery -->
            <div id="modal-gallery" class="modal modal-gallery hide fade" data-filter=":odd">
                <div class="modal-header">
                    <a class="close" data-dismiss="modal">&times;</a>

                    <h3 class="modal-title"></h3>
                </div>
                <div class="modal-body">
                    <div class="modal-image"></div>
                </div>
                <div class="modal-footer">
                    <a class="btn modal-download" target="_blank">
                        <i class="icon-download"></i>
                        <span>下载</span>
                    </a>
                    <a class="btn btn-success modal-play modal-slideshow" data-slideshow="5000">
                        <i class="icon-play icon-white"></i>
                        <span>Slideshow</span>
                    </a>
                    <a class="btn btn-info modal-prev">
                        <i class="icon-arrow-left icon-white"></i>
                        <span>上一个</span>
                    </a>
                    <a class="btn btn-primary modal-next">
                        <span>下一个</span>
                        <i class="icon-arrow-right icon-white"></i>
                    </a>
                </div>
            </div>
            <!-- The template to display files available for upload -->
            <script id="template-upload" type="text/x-tmpl">
                {% for (var i=0, file; file=o.files[i]; i++) { %}
                <tr class="template-upload fade">
                    <td class="preview"><span class="fade"></span></td>
                    <td class="name"><span>{%=file.name%}</span></td>
                    <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
                    {% if (file.error) { %}
                    <td class="error" colspan="2"><span
                            class="label label-important">{%=locale.fileupload.error%}</span>
                        {%=locale.fileupload.errors[file.error] || file.error%}
                    </td>
                    {% } else if (o.files.valid && !i) { %}
                    <td>
                        <div class="progress progress-success progress-striped active" role="progressbar"
                             aria-valuemin="0" aria-valuemax="100" aria-valuenow="0">
                            <div class="bar" style="width:0%;"></div>
                        </div>
                    </td>
                    <td class="start">{% if (!o.options.autoUpload) { %}
                        <button class="btn btn-primary">
                            <i class="icon-upload icon-white"></i>
                            <span>{%=locale.fileupload.start%}</span>
                        </button>
                        {% } %}
                    </td>
                    {% } else { %}
                    <td colspan="2"></td>
                    {% } %}
                    <td class="cancel">{% if (!i) { %}
                        <button class="btn btn-warning">
                            <i class="icon-ban-circle icon-white"></i>
                            <span>{%=locale.fileupload.cancel%}</span>
                        </button>
                        {% } %}
                    </td>
                </tr>
                {% } %}
            </script>
            <!-- The template to display files available for download -->
            <script id="template-download" type="text/x-tmpl">
                {% for (var i=0, file; file=o.files[i]; i++) { %}
                <tr class="template-download fade">
                    {% if (file.error) { %}
                    <td></td>
                    <td class="name"><span>{%=file.name%}</span></td>
                    <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
                    <td class="error" colspan="2"><span
                            class="label label-important">{%=locale.fileupload.error%}</span>
                        {%=locale.fileupload.errors[file.error] || file.error%}
                    </td>
                    {% } else { %}
                    <td class="preview">{% if (file.thumbnail_url) { %}
                        <a href="{%=file.url%}" title="{%=file.name%}" rel="gallery" download="{%=file.name%}"><img
                                src="{%=file.thumbnail_url%}"></a>
                        {% } %}
                    </td>
                    <td class="name">
                        <a href="{%=file.url%}" title="{%=file.name%}" rel="{%=file.thumbnail_url&&'gallery'%}"
                           download="{%=file.name%}">{%=file.name%}</a>
                    </td>
                    <td class="size"><span>{%=o.formatFileSize(file.size)%}</span></td>
                    <td colspan="2"></td>
                    {% } %}
                    <td class="delete">
                        <button class="btn btn-danger" data-type="{%=file.delete_type%}"
                                data-url="{%=file.delete_url%}">
                            <i class="icon-trash icon-white"></i>
                            <span>{%=locale.fileupload.destroy%}</span>
                        </button>
                        <input type="checkbox" name="delete" value="1">
                    </td>
                </tr>
                {% } %}
            </script>
        </div>
    </div>
</div>
</div>
<script type="text/javascript"
        src="${ctx}/min?t=js&f=/js/main.js,/js/filetree/jquery.treeview.js,/js/fancyBox/jquery.mousewheel-3.0.6.pack.js,/js/fancyBox/jquery.fancybox.pack.js,/js/fancyBox/helpers/jquery.fancybox-buttons.js,/js/fancyBox/helpers/jquery.fancybox-thumbs.js,/js/jquery-ui/jquery-ui-1.8.23.custom.min.js,/js/fileupload/vendor/jquery.ui.widget.js,/js/fileupload/tmpl.min.js,/js/fileupload/jquery.iframe-transport.js,/js/fileupload/jquery.fileupload.js,/js/fileupload/load-image.min.js,/js/fileupload/canvas-to-blob.min.js,/js/fileupload/jquery.fileupload-fp.js,/js/fileupload/jquery.fileupload-ui.js,/js/fileupload/locale.js"></script>
<!--[if gte IE 8]>
<script src="type=" text/javascript" src="${ctx}/static/js/fileupload/cors/jquery.xdr-transport.js"></script>
<![endif]-->
<script type="text/javascript">
    $(function () {
        $("#file-page").addClass("active");

        $("#fileupload").fileupload({
            dataType:'json',
            maxFileSize:500000000, //500MB
            acceptFileTypes:/(\.|\/)(gif|jpe?g|png|mp4|avi|flv)$/i,
            process:[
                {
                    action:'load',
                    fileTypes:/^image\/(gif|jpeg|png)$/,
                    maxFileSize:20000000 // 20MB
                },
                {
                    action:'resize',
                    maxWidth:1440,
                    maxHeight:900
                },
                {
                    action:'save'
                }
            ],
            done:function (e, data) {
                $.each(data.result, function (index, file) {
                    $('<p/>').text(file.name).appendTo(document.body);
                });
            },
            progressall:function (e, data) {
                var progress = parseInt(data.loaded / data.total * 100, 10);
                $('#progress .bar').css(
                        'width',
                        progress + '%'
                );
            }
        });

        //分页
        var nodeId;
        var files = $("#file-items");
        var pager = $("#pagination");
        PageClick = function (nodeId, pageIndex, total, spanInterval) {
            //索引从1开始
            //将当前页索引转为int类型
            var intPageIndex = parseInt(pageIndex);
            var limit = 8;//每页显示文章数量

            $.ajax({
                url:"${ctx}/api/file/list/" + nodeId + "?offset=" + (intPageIndex - 1) * limit + "&limit=" + limit,
                timeout:3000
            }).done(function (data) {
                        //加载文件
                        files.html("");
                        $.each(data, function (index, item) {
                            var row = "<tr><td><label class='checkbox'><input type='checkbox' name='subBox' value=''></label></td><td><a href='${ctx}/file/get/" + item.id + "'>" + item.customName + "</a></td><td>" + <c:forEach items="${nodeTypes}" var="nodeType" begin="0" step="1"><c:if test="${nodeType.value==item.node.type.value}">${nodeType.displayName}</c:if></c:forEach> +"</td><td> " + (item.size) / 1024 + " KB </td><td>" + ChangeDateFormat(item.createdDate) + "</td><td>" + item.md5 + "</td><td><a href='#'><i class='icon-star' title='收藏'></i></a> | ";
                            if (item.status)
                                row += "<a href='${ctx}/file/get/" + item.id + "'><i class='icon-download' title='下载'></i></a> | ";
                            if (item.shared)
                                row += "<a href='${ctx}/share/create/" + item.id + "'><i class='icon-share' title='分享'></i></a> | ";
                            row = row.substr(0, row.length - 3);
                            row += "</td>";
                            // TODO 判断管理员身份
                            row += "<td><a href='${ctx}/file/edit/" + item.id + "'><i class='icon-pencil' title='修改'></i></a> | <a href='#'><i class='icon-eye-close' title='禁止下载'></i></a> | <a href='${ctx}/file/delete/" + item.id + "'><i class='icon-remove' title='删除'></i></a></td></tr>";
                            files.append(row);
                        });

                        //将总记录数结果 得到 总页码数
                        var pageS = total;
                        if (pageS % limit == 0) pageS = pageS / limit;
                        else pageS = parseInt(total / limit) + 1;

                        //设置分页的格式  这里可以根据需求完成自己想要的结果
                        var interval = parseInt(spanInterval); //设置间隔
                        var start = Math.max(1, intPageIndex - interval); //设置起始页
                        var end = Math.min(intPageIndex + interval, pageS);//设置末页

                        if (intPageIndex < interval + 1) {
                            end = (2 * interval + 1) > pageS ? pageS : (2 * interval + 1);
                        }

                        if ((intPageIndex + interval) > pageS) {
                            start = (pageS - 2 * interval) < 1 ? 1 : (pageS - 2 * interval);
                        }

                        //生成页码
                        pager.html("");
                        for (var j = start; j < end + 1; j++) {
                            if (j == intPageIndex) {
                                pager.append("<li class='active'><a href='#'>" + j + "</a></li>");
                            } else {
                                var a = $("<li><a href='#'>" + j + "</a></li>").click(function () {
                                    PageClick(nodeId, $(this).text(), total, spanInterval);
                                });
                                pager.append(a);
                            } //else
                        } //for
                    });
        };

        // 目录树
        $("#browser").treeview();
        $(".leafnode").click(function () {
            $("#file-list").show();
            nodeId = $(this).attr("id");
            $.ajax({
                url:"${ctx}/api/file/count/" + nodeId,
                timeout:3000
            }).done(function (data) {
                        PageClick(nodeId, 1, data, 5);
                    });
        });

        // 图片展示控制
        $(".fancybox").fancybox();
        $(".thumbnail").click(function () {
            $.fancybox.open([
                {
                    href:'${ctx}/static/images/psb.jpg',
                    title:'My title'
                },
                {
                    href:'${ctx}/static/images/psb1.jpg',
                    title:'1st title'
                },
                {
                    href:'${ctx}/static/images/psb2.jpg',
                    title:'2nd title'
                },
                {
                    href:'${ctx}/static/images/psb3.jpg',
                    title:'3td title'
                }
            ], {
                helpers:{
                    thumbs:{
                        width:75,
                        height:50
                    }
                }
            });
        });
    });
</script>
</body>
</html>