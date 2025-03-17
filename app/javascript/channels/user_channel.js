import consumer from "channels/consumer"

const createSubscription = () {
  consumer.subscriptions.create("UserChannel", {
    connected() {
      // Called when the subscription is ready for use on the server
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
    },

    project_update: function() {
      return this.perform('project_update');
    }
  });
}
export default createSubscription
