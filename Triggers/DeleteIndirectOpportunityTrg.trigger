trigger DeleteIndirectOpportunityTrg on Opportunity (after delete)  
{
	List<Indirect_Opportunity__c> listIndirectOpp = [select id from Indirect_Opportunity__c where Opportunity__c = :Trigger.Old
}