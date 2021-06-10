// Getting all navigation button links and mapping them
document.querySelectorAll("[nav]").forEach(link =>{
    // Getting html from main container (display container)
    const content = document.getElementById("display-container")

    // First page must be home page
    if(link.getAttribute("nav") == "pages/home.html"){                    
        // Getting html from the provided link and replacing into display container
        fetch(link.getAttribute("nav"))
            .then(resp => resp.text())
            .then(html => content.innerHTML = html)
    }

    // When click on link
    link.onclick = function(e) {
        // Don't know what this does
        e.preventDefault()
        
        // Getting html from the provided link and replacing into display container
        fetch(link.getAttribute("nav"))
            .then(resp => resp.text())
            .then(html => content.innerHTML = html)
    }
})