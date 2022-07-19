/**
 * Created by wamohd on 15.07.2022.
 **/

public with sharing class AccountTriggerHandler {
    private class ResponseWrapper {
        public List<Name> results;

    }
    private class Name {
        public String first;
        public String last;
    }
    private class Person {
        public Name name;
    }


    public static void handleAfterInsert(Set<Id> newAccountsIds) {
        getRandomUser(newAccountsIds);
    }

    @Future(Callout=true)
    private static void getRandomUser(Set<Id> newAccountIds) {
        HttpRequest request = new HttpRequest();
        final String nat = 'gb';
        final Integer results = newAccountIds.size();
        request.setEndpoint('https://randomuser.me/api/?nat=' + nat + '&results=' + results);
        request.setMethod('GET');
        HttpResponse response = new Http().send(request);
        System.debug(response.getBody());
        ResponseWrapper wrapper = (ResponseWrapper) JSON.deserialize(response.getBody(), ResponseWrapper.class);
        System.debug(wrapper);
        List<Id> accountIds = new List<Id>(newAccountIds);
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < wrapper.results.size(); ++i) {

            contacts.add(new Contact(AccountId = accountIds[i],
                    FirstName = wrapper.results[i].first,
                    LastName = wrapper.results[i].last
            ));

        }
        insert contacts;
    }
}