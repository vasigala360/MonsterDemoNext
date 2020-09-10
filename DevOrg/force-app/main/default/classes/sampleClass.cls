global class sampleClass implements Messaging.InboundEmailHandler {
      global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
          Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
          Account acc = new Account();
          acc.Name = 'Testing Email Service';
          insert acc;
          return result;
      }
  }