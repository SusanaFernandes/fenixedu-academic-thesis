<%--

    Copyright © 2014 Instituto Superior Técnico

    This file is part of FenixEdu Academic Thesis.

    FenixEdu Academic Thesis is free software: you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    FenixEdu Academic Thesis is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with FenixEdu Academic Thesis.  If not, see <http://www.gnu.org/licenses/>.

--%>
<!DOCTYPE html>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>


${portal.toolkit()}

<div class="page-header">
	<h1><spring:message code="title.thesisProposal.management"/></h1>
</div>

<div class="well">
	<p><spring:message code="label.proposals.well"/></p>
	<p><spring:message code="label.configuration"/></p>
	<c:if test="${!empty configsList}">
				<form role="form" method="GET" action="${pageContext.request.contextPath}/proposals" class="form-horizontal" id="thesisConfigForm">
				<select name="configuration" class="form-control">
					<c:forEach items="${configsList}" var="config">
						<option <c:if test="${config.externalId eq configuration.externalId}">selected="selected"</c:if> value="${config.externalId}" label='${config.presentationName}'/>
					</c:forEach>
				</select>
			</form>
	</c:if>
</div>

<c:if test="${!empty deleteException}">
	<p class="text-danger"><spring:message code="error.thesisProposal.delete"/></p>
</c:if>

<c:if test="${!empty error}">
	<p class="text-danger"><spring:message code="error.thesisProposal.${error}"/></p>
</c:if>

<c:if test="${!empty suggestedConfigs}">
	<div class="alert alert-info">
		<c:forEach items="${suggestedConfigs}" var="config">
			<p>
				<p><spring:message code="label.thesis.proposal.info" arguments="${configuration.presentationName},${configuration.proposalPeriod.start.toString('dd-MM-YYY HH:mm')},${configuration.proposalPeriod.end.toString('dd-MM-YYY HH:mm')}"/></p>
				<p><spring:message code="label.thesis.candidacy.info" arguments="${configuration.presentationName},${configuration.candidacyPeriod.start.toString('dd-MM-YYY HH:mm')},${configuration.candidacyPeriod.end.toString('dd-MM-YYY HH:mm')}"/></p>
			</p>
		</c:forEach>
	</div>
</c:if>

	<span class="row">
		<div class="col-sm-8">
			<form role="form" method="GET" action="${pageContext.request.contextPath}/proposals/create" class="form-horizontal" id="thesisProposalCreateForm">
				<button type="submit" class="btn btn-default"><spring:message code="button.create"/></button>
			</form>
			<form role="form" method="GET" action="${pageContext.request.contextPath}/proposals/transpose" class="form-horizontal" id="thesisProposalTransposeForm">
				<button type="submit" class="btn btn-default"><spring:message code="button.transpose"/></button>
			</form>
		</div>
	</span>
	
<c:if test="${not empty thesisProposalsList}">
	<div class="table-responsive">
		<table class="table">
			<thead>
				<tr>
					<th>
						<spring:message code='label.thesis.id'/>
					</th>
					<th>
						<spring:message code='label.year'/>
					</th>
					<th>
						<spring:message code='label.title'/>
					</th>
					<th>
						<spring:message code='label.participants'/>
					</th>
					<th>
						<spring:message code='label.proposal.status'/>
					</th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${thesisProposalsList}" var="thesisProposal">
					<tr>
						<td>${thesisProposal.identifier}</td>
						<td>
							${thesisProposal.getSingleThesisProposalsConfiguration().executionDegree.executionYear.year}
						</td>
						<td>${thesisProposal.title}</td>
						<td>
							<c:forEach items="${thesisProposal.getSortedParticipants()}" var="participant">
								<div>${participant.user.name} <small>as</small> <b>${participant.thesisProposalParticipantType.name.content}</b></div>
							</c:forEach>
						</td>
						<td>
							<c:if test="${thesisProposal.hidden}">
								<spring:message code='label.proposal.status.hidden'/>
							</c:if>
							<c:if test="${!thesisProposal.hidden}">
								<spring:message code='label.proposal.status.visible'/>
							</c:if>
							</td>
						<td>
							<form:form method="GET" action="${pageContext.request.contextPath}/proposals/edit/${thesisProposal.externalId}">
								<input type="hidden" name="configuration" value="${configuration.externalId}"/>
								<div class="btn-group btn-group-xs">
									<button type="submit" class="btn btn-default" id="editButton">
										<spring:message code='button.edit'/>
									</button>

									<c:set var="result" scope="session" value=''/>
									<c:forEach items="${thesisProposal.executionDegreeSet}" var="executionDegree" varStatus="i">
										<c:set var="result" scope="session" value="${result}${executionDegree.degree.sigla}" />
										<c:if test="${i.index != thesisProposal.executionDegreeSet.size() - 1}">
											<c:set var="result" scope="session" value="${result}, " />
										</c:if>
									</c:forEach>

									<input type='button' class='detailsButton btn btn-default' data-observations="${thesisProposal.observations}" data-requirements="${thesisProposal.requirements}" data-goals="${thesisProposal.goals}" data-localization="${thesisProposal.localization}" data-degrees="${result}" value='<spring:message code="button.details"/>' data-thesis="${thesisProposal.externalId}">

									<c:if test="${thesisProposal.studentThesisCandidacy.size() > 0}">
										<button type="button" class="btn btn-default manageButton" data-thesis-proposal="${thesisProposal.externalId}"><spring:message code="label.candidacies.manage"/></button>
									</c:if>
								</div>
							</form:form>
							<form method="GET" action="${pageContext.request.contextPath}/proposals/manage/${thesisProposal.externalId}" id='${thesisProposal.externalId}'></form>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</c:if>

<style>
form{
	display: inline
}
</style>

<!-- Modal -->
<div class="modal fade" id="view" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="form-horizontal modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close"><span class="sr-only"><spring:message code="button.close"/></span></button>
				<h3 class="modal-title"><spring:message code="label.details"/></h3>
				<small class="explanation"><spring:message code="label.modal.proposals.details"/></small>
			</div>
			<div class="modal-body">
				<div class="form-group">
					<label for="name" path="name" class="col-sm-2 control-label"><spring:message code='label.goals'/></label>
					<div class="col-sm-10">
						<div class="information goals"></div>
					</div>
				</div>

				<div class="form-group">
					<label for="name" path="name" class="col-sm-2 control-label"><spring:message code='label.requirements'/></label>
					<div class="col-sm-10">
						<div class="information requirements"></div>
					</div>
				</div>

				<div class="form-group">
					<label for="name" path="name" class="col-sm-2 control-label"><spring:message code='label.localization'/></label>
					<div class="col-sm-10">
						<div class="information localization"></div>
					</div>
				</div>

				<div class="form-group">
					<label for="name" path="name" class="col-sm-2 control-label"><spring:message code='label.observations'/></label>
					<div class="col-sm-10">
						<div class="information observations"></div>
					</div>
				</div>

				<div class="form-group">
					<label for="name" path="name" class="col-sm-2 control-label"><spring:message code='label.executionDegrees'/></label>
					<div class="col-sm-10">
						<div class="information degrees"></div>
					</div>
				</div>

			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal"><spring:message code='button.close'/></button>
			</div>
		</div>
	</div>
</div>

<style type="text/css">
.information{
	margin-top: 7px;
	margin-left: 10px;
}
</style>

<script type="text/javascript">



$(".manageButton").on("click", function(){
	var id = $(this).data('thesis-proposal')
	$("#" + id).submit();
})


jQuery(document).ready(function(){
	jQuery('.detailsButton').on('click', function(event) {
		$("#details" + $(this).data("thesis")).toggle('show');

	});

	$("select[name=configuration]").change(function() {
		$("#thesisConfigForm").submit();
	});
});

$(function(){
	$(".detailsButton").on("click", function(evt){
		var e = $(evt.target);

		['observations','requirements','goals','localization','degrees'].map(function(x){
			$("#view ." + x).html(e.data(x));
		});

		$('#view').modal('show');
	});
})
</script>
