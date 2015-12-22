/*
@author: Atif Hassan
@description: This trigger handles if some other account is set as a parent account, then it tags existing opportunities
              of child account as indirect opportunities to its parent account
@creation date: 8th December 2015
@modification date: 
*/
trigger AccountUpdateTrg on Account (after update)  
{ 
    if ((Trigger.old[0].ParentId == null && Trigger.new[0].ParentId != null) ||
        (Trigger.old[0].ParentId != null && Trigger.new[0].ParentId == null) ||
        ((Trigger.old[0].ParentId != null && Trigger.new[0].ParentId != null) && (Trigger.old[0].ParentId != Trigger.new[0].ParentId)))
    {
        
        List<Indirect_Opportunity__c> listIndOpp = new List<Indirect_Opportunity__c>();
        List<Opportunity> listOpp;

        if (Trigger.old[0].ParentId == null && Trigger.new[0].ParentId != null)
        {
            listOpp = [select Id, AccountId, Account.ParentId from Opportunity where AccountId = :Trigger.new[0].Id];
            
            for (Opportunity opp : listOpp)
            {
                Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c();
                indOpp.Opportunity__c = opp.Id;
                indOpp.Account__c = Trigger.new[0].ParentId;       //opp.Account.ParentId;
                
                listIndOpp.add(indOpp); 
            }
            
            insert listIndOpp;
			listIndOpp.clear();
        }
        
        /*
        if some account was parent now it's been removed as a parent, below code removes parent accounts relevant records
        from Indirect Opportunity object    
        */
        if (Trigger.old[0].ParentId != null && Trigger.new[0].ParentId == null)
        {
            listOpp = [select Id from Opportunity where AccountId = :Trigger.old[0].Id];

            listIndOpp = [select Id from Indirect_Opportunity__c 
                          where Account__c = :Trigger.old[0].ParentId
                          and Opportunity__c = :listOpp];

            delete listIndOpp;
			listIndOpp.clear();
        }

        /* 
        if old parent was not null, new parent is assigned then remove old records and insert new entries in 
        Indirect Opportunity Object
        */
        if ((Trigger.old[0].ParentId != null && Trigger.new[0].ParentId != null) && (Trigger.old[0].ParentId != Trigger.new[0].ParentId))
        {
            listOpp = [select Id from Opportunity where AccountId = :Trigger.old[0].Id];

            listIndOpp = [select Id from Indirect_Opportunity__c 
                          where Account__c = :Trigger.old[0].ParentId
                          and Opportunity__c = :listOpp];

            delete listIndOpp;
			listIndOpp.clear();
            
            listOpp = [select Id, AccountId from Opportunity where AccountId = :Trigger.new[0].Id];
            
            for (Opportunity opp : listOpp)
            {
                Indirect_Opportunity__c indOpp = new Indirect_Opportunity__c();
                indOpp.Opportunity__c = opp.Id;
                indOpp.Account__c = Trigger.new[0].ParentId;       //opp.Account.ParentId;
                
                listIndOpp.add(indOpp); 
            }
            
            insert listIndOpp;      
			listIndOpp.clear();                
        }
    }
}