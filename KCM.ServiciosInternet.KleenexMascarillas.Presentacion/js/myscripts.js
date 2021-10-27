window.addEventListener('scroll', function()  {
    let element = document.getElementById('icon_element');
    let screenSize = window.innerHeight;
    
      if(element.getBoundingClientRect().top < screenSize) {
        element.classList.add('visible');
      } else {
        element.classList.remove('visible');
      }
  });
  
  window.addEventListener('scroll', function()  {
    let element = document.getElementById('presentaciones');
    let screenSize = window.innerHeight;
    
      if(element.getBoundingClientRect().top < screenSize) {
        element.classList.add('visible2');
      } else {
        element.classList.remove('visible2');
      }
  });