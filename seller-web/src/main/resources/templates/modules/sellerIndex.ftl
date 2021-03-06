<#include "/include/taglib.ftl" >
<#include "/include/chart.ftl" >
<div class="page-container-custom">
    <div class="page-bar">
        <ul class="page-breadcrumb">
            <li>
                <i class="icon-home"></i>
                <a target="_parent" href="${ctx}"><@spring.message code="merchant.home"></@spring.message></a>
                <i class="fa fa-angle-right"></i>
            </li>
        </ul>
    </div>

<div class="portlet light ">
    <div class="portlet-title">
        <div class="caption">
            <span class="caption-subject font-green bold"><@spring.message code="merchant.revenue.statistics"></@spring.message></span>
        </div>
    </div>

    <div class="portlet-body form">
        <!-- BEGIN FORM-->

        <div class="row">
            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2 margin-bottom-10" style="width:33%;">
                <div class="dashboard-stat blue-madison">
                    <div class="visual">
                        <i class="fa  fa-jpy"></i>
                    </div>
                    <div class="details">
                        <div class="number">
                       ${total!0}
                         <span style="font-size:16px">${userCurrency!}</span>
                        </div>
                        <div class="desc">
                        	<@spring.message code="merchant.revenue.total"></@spring.message>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2" style="width:33%;">
                <div class="dashboard-stat red-intense">
                    <div class="visual">
                        <i class="fa  fa-jpy"></i>
                    </div>
                    <div class="details">
                        <div class="number">
                         ${today!0}
                         <span style="font-size:16px">${userCurrency!}</span>
                        </div>
                        <div class="desc">
                        	<@spring.message code="merchant.revenue.today"></@spring.message>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-2 col-md-2 col-sm-2 col-xs-2" style="width:33%;">
                <div class="dashboard-stat yellow">
                    <div class="visual">
                        <i class="fa  fa-jpy"></i>
                    </div>
                    <div class="details">
                        <div class="number">
                         	 ${yestoday!0}
                         	<span style="font-size:16px">${userCurrency!}</span>
                        </div>
                        <div class="desc">
                            	<@spring.message code="merchant.revenue.yesterday"></@spring.message>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</div>

<div class="portlet light ">
    <div class="portlet-title">
        <div class="caption">
            <span class="caption-subject font-green bold"><@spring.message code="merchant.revenue.logs"></@spring.message></span>
        </div>
    </div>

    <div class="portlet-body form">
        <!-- BEGIN FORM-->
		<@form.form id="searchForm" modelAttribute="vo" action="${ctx}/index" method="post" class="breadcrumb form-search">
			<div>
            	&nbsp;&nbsp;&nbsp;
            	 <@form.select id="statsType" path="statsType" class="select2 form-control input-small">
            	 	<@form.option value="1"><@spring.message code="merchant.revenue.dailyStatistics"></@spring.message></@form.option>
            	 	<@form.option value="2"><@spring.message code="merchant.revenue.monthlyStatistics"></@spring.message></@form.option>
            	 </@form.select>
            	 &nbsp;&nbsp;&nbsp;
            	 <span id="yearSpan"  <#if vo.statsType=='2'>style="display:none;"</#if>>
            	 <input  name="year" type="text" readonly="readonly" maxlength="20" class="form-control input-small input-inline"
            	 value="${vo.year!}" onclick="WdatePicker({dateFmt:'yyyy',isShowClear:false});"/>
            	 </span>
            	 <span id="monthSpan" <#if vo.statsType=='1'>style="display:none;"</#if>>
            	 <input  name="month" type="text" readonly="readonly" maxlength="20" class="form-control input-small input-inline"
            	 value="${vo.month!}" onclick="WdatePicker({dateFmt:'yyyy-MM',isShowClear:false});"/>
            	 </span>
                &nbsp;&nbsp;&nbsp;<input id="btnSubmit" class="btn btn-primary" type="submit" value="query" />
            </div>
		</@form.form>
        <div class="portlet-body form">
                <!-- BEGIN FORM-->
				<div id="userNumsLine" style="height:300px; "></div>
        </div>

    </div>
</div>

</div>
<script type="text/javascript">
		$("#statsType").change(function(){
			if($("#statsType").val()=='1'){
				$("#yearSpan").show();
				$("#monthSpan").hide();
			}else{
				$("#yearSpan").hide();
				$("#monthSpan").show();
			}
		});
        require(
            [
                'echarts',
                'echarts/theme/macarons',
                'echarts/chart/line',   
                'echarts/chart/pie', 
                'echarts/chart/bar'
            ],
            function (ec, theme) {
            	//=====start=====
                var userNumsLine = ec.init(document.getElementById('userNumsLine'), theme);
                userNumsLine.setOption(
                	{
                		title : {
					        text: '${vo.time!}&nbsp;&nbsp;<@spring.message code="merchant.revenue.logs"></@spring.message>',
					        x:'left'
					    },
					    tooltip : {
					        trigger: 'axis'
					    },
					     legend: {
					        data:['<@spring.message code="merchant.revenue.logs"></@spring.message>']
					    },
					    toolbox: {
					        show : true,
					        feature : {
					        	dataView : {show: true, readOnly: false},
            					restore : {show: true},
					            saveAsImage : {show: true}
					        }
					    },
					    calculable : true,
					    xAxis : [
					        {
					            type : 'category',
					            boundaryGap : false,
					            data : ${timeStr!}
					        }
					    ],
					    yAxis : [
					        {
					            type : 'value',
					            axisLabel : {
					                formatter: '{value}'
					            }
					        }
					    ],
					    series : [
					        {
					            name:'<@spring.message code="merchant.revenue.logs"></@spring.message>',
					            type:'line',
					            data:
									${numStr!}
								
					        }
					    ]
					}
                );
              
            }
        );
    </script>
