self.addEventListener("push", (event) => {
  const data = event.data.json();
  console.log("Push Received:", data);

  self.registration.showNotification(data.title, {
    body: data.message,
    icon: "/icon-192x192.png",
  });
});
