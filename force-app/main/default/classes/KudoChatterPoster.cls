public with sharing class KudoChatterPoster {
    public KudoChatterPoster() {}
    
    public static Boolean postToChatter(String kudotype,String kudoDescription,Id groupId,Set<Id> usersToMention){
        
            // Kudo Edit Controller passes down the selected Employee Ids in a Set
            List<Id> usersToMentionList = new List<Id>();
            usersToMentionList.addAll(usersToMention);  // All Items into a List
        
            Boolean postingSuccess = false;

        if( kudoType == 'Group'){

            ConnectApi.MessageBodyInput messageWithInitialText = createPostBodyUptoInitialText();
            
            List<ConnectApi.MessageSegmentInput> multipleMentions = createMultipleMentions(usersToMentionList);
            
            messageWithInitialText.messageSegments.addAll(multipleMentions);

            messageWithInitialText = decorateMoreItemsToMessage(messageWithInitialText,kudoDescription);

            // Creating the Feed Item
            ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
            feedItemInput.body = messageWithInitialText;      // Giving Body as the one created before
            feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;      //FeedElement Type is given a value of FeedItem through Enum
    
            feedItemInput.subjectId = groupId; // GroupId
			
            ConnectApi.FeedElement result = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
            
            postingSuccess = result.Id != null ? true : false;

            return postingSuccess;
        }

        else {

            Map<Id,ConnectApi.MessageBodyInput> feedBatchMessagesMap = new Map<Id,ConnectApi.MessageBodyInput>();

            for(Id eachMember : usersToMentionList){
            
                ConnectApi.MessageBodyInput messageWithInitialTextIndiv = createPostBodyUptoInitialText();

                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = eachMember;   
                
                messageWithInitialTextIndiv.messageSegments.add(mentionSegmentInput);

                messageWithInitialTextIndiv = decorateMoreItemsToMessage(messageWithInitialTextIndiv,kudoDescription);

                feedBatchMessagesMap.put(eachMember,messageWithInitialTextIndiv);
            }

            for(Id eachMember : usersToMentionList){

                // Creating the Feed Item
                ConnectApi.FeedItemInput feedItemInput = new ConnectApi.FeedItemInput();
                feedItemInput.body = feedBatchMessagesMap.get(eachMember);      // Giving Body as the one created before
                feedItemInput.feedElementType = ConnectApi.FeedElementType.FeedItem;      //FeedElement Type is given a value of FeedItem through Enum
        
                feedItemInput.subjectId = groupId; // GroupId

                ConnectApi.FeedElement result = ConnectApi.ChatterFeeds.postFeedElement(Network.getNetworkId(), feedItemInput, null);
            
                postingSuccess = result.Id != null ? true : false;
            }
        
            return postingSuccess; 
        }
    }

    private static ConnectApi.MessageBodyInput createPostBodyUptoInitialText(){
        // Creating a MessageBody Input
        ConnectApi.MessageBodyInput messageBodyInput = new ConnectApi.MessageBodyInput();
        messageBodyInput.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        // Creating a Text Segment Input
        ConnectApi.TextSegmentInput textSegment1 = new ConnectApi.TextSegmentInput();
        textSegment1.text = 'Kudos Presented To : ';
        
        messageBodyInput.messageSegments.add(textSegment1);   // Adding Initial Text

        return messageBodyInput;
    }

    private static ConnectApi.MessageBodyInput decorateMoreItemsToMessage( ConnectApi.MessageBodyInput messageBodyInput, String kudoDescription){
        
        // Crafting the User Provided Kudo Description
        ConnectApi.TextSegmentInput textSegment2 = new ConnectApi.TextSegmentInput();
        textSegment2.text = '\n\n '+kudoDescription;
        
        // Crafting the 'Presented By' Text
        ConnectApi.TextSegmentInput textSegment3 = new ConnectApi.TextSegmentInput();
        textSegment3.text = '\n\n Presented By : '+UserInfo.getName();
        
        messageBodyInput.messageSegments.add(textSegment2);   // Adding Description
        messageBodyInput.messageSegments.add(textSegment3);   // Adding Final Text

        return messageBodyInput;
    }

    private static List<ConnectApi.MessageSegmentInput> createMultipleMentions(List<Id> usersToMentionList){

        List<ConnectApi.MessageSegmentInput> tempSegments = new List<ConnectApi.MessageSegmentInput>();

            // For Each User in the Selected List , generate a Text Type punctuation mark TextSegment    
            for(Integer i=0 ; i < usersToMentionList.size() ; i++){
                
                ConnectApi.TextSegmentInput punctuations = new ConnectApi.TextSegmentInput();
                punctuations.text = ', ';
                tempSegments.add(punctuations);

                ConnectApi.MentionSegmentInput mentionSegmentInput = new ConnectApi.MentionSegmentInput();
                mentionSegmentInput.id = usersToMentionList.get(i);
                tempSegments.add(mentionSegmentInput);  // In a loop adding all the User Mentions
                
            }
            
            // Removing the Comma Punctuation unnecessary and ahead of the First Name
            tempSegments.remove(0);

        return tempSegments;
    }
}