/*
@author: Atif Hassan
@description: This trigger handles insertion of opportunity in junction object so that, that opportunity could 
              be shown on parent Account's indirect opportunity (loan) related list as well.
@creation date: 3rd December 2015
@modification date: 
*/

trigger OpportunityInsertTrg on Opportunity (after insert)  
{ 
	OpportunityHelper oppHelper = new OpportunityHelper();
	oppHelper.handleOpportunityInsert(Trigger.New);
}