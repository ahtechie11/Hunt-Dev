/*
@author: Atif Hassan
@description: This trigger handles if some other account is tagged on opportunity, then it removes parent of
              old account and inserts parent of newly tagged account in junction object.
@creation date: 3rd December 2015
@modification date: 
*/

trigger OpportunityUpdateTrg on Opportunity (after update)  
{ 
    OpportunityHelper oppHelper = new OpportunityHelper();
	oppHelper.handleOpportunityUpdate(Trigger.old, Trigger.new);
}