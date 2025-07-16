import consumer from "./consumer"

document.
  querySelectorAll('[data-projects-channel]').
  forEach( (el) => {
    const projectId = el.dataset['projectsChannel'];
    consumer.subscriptions.create({ "channel": "ProjectsChannel", "id": projectId }, {
      connected() {
        console.log('Connected');
        // Called when the subscription is ready for use on the server
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        console.log('Received', data);

        var element = document.querySelector(`[data-setup-project='${projectId}']`);
        if (element && data.group_setup_page) {
          element.innerHTML = data.group_setup_page;
          document.querySelectorAll('[data-checkbox-value="true"]').forEach((element) => { element.classList.add('animate__animated', 'animate__bounceIn'); });
        }
      }
    });
  });
