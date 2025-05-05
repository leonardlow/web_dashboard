function fetchData(pair) {
    fetch('backend/firewall_data.json')
        .then(response => response.json())
        .then(data => {
            let content = `<h2>${pair.charAt(0).toUpperCase() + pair.slice(1)} Pair Data</h2>`;
            content += `<pre>${JSON.stringify(data[pair], null, 2)}</pre>`;
            document.getElementById('content').innerHTML = content;
        })
        .catch(error => console.error('Error fetching data:', error));
}

function showOldPair() {
    fetchData('old_pair');
}

function showNewPair() {
    fetchData('new_pair');
}

function submitForm() {
    const old_ipv4 = document.getElementById('old_ipv4').value;
    const old_ipv6 = document.getElementById('old_ipv6').value;
    const new_ipv4 = document.getElementById('new_ipv4').value;
    const new_ipv6 = document.getElementById('new_ipv6').value;

    fetch('backend/data_collection.py', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            old_ipv4: old_ipv4,
            old_ipv6: old_ipv6,
            new_ipv4: new_ipv4,
            new_ipv6: new_ipv6
        })
    })
    .then(response => response.json())
    .then(data => {
        console.log('Data collected:', data);
    })
    .catch(error => console.error('Error:', error));
}
