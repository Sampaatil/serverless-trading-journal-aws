// ---------- CONFIG ----------
const API_URL = "https://u0qx92jxm5.execute-api.ap-south-1.amazonaws.com/Prod"

let chart = null
let editTradeId = null

// ---------- AUTH HEADER ----------
function getAuthHeaders() {
  const token = localStorage.getItem("token");

  console.log("Authorization Header");
  console.log(token);

  if (!token || token === "null" || token === "undefined") {
    throw new Error("Missing or invalid token");
  }

  return {
    "Content-Type": "application/json",
    "Authorization": `Bearer ${token}`
  };
}

// ---------- INIT ----------
window.onload = () => {
  month.onchange = () => {
    loadTrades();
};
  let today = new Date()
  date.value = today.toISOString().split('T')[0]
  month.selectedIndex = today.getMonth()

// Default filter = current month
  month.value = month.options[today.getMonth()].value;

  const token = localStorage.getItem("token")

  if (token && token !== "null" && token !== "undefined") {
    front.classList.add("hidden")
    dashboard.classList.remove("hidden")
    loadTrades()
  } else {
    front.classList.remove("hidden")
    dashboard.classList.add("hidden")
  }
}

// ---------- AUTH UI ----------
function openSignup(){
  signupBox.classList.remove("hidden")
  loginBox.classList.add("hidden")
}

function openLogin(){
  loginBox.classList.remove("hidden")
  signupBox.classList.add("hidden")
}

// ---------- SIGNUP ----------
async function signup(){
  let mobile = suMobile.value.trim()
  let pass = suPass.value.trim()

  if(!mobile || !pass){
    alert("Enter mobile and password")
    return
  }

  let res = await fetch("https://cognito-idp.ap-south-1.amazonaws.com/", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-amz-json-1.1",
      "X-Amz-Target": "AWSCognitoIdentityProviderService.SignUp"
    },
    body: JSON.stringify({
      ClientId: "201u029eenl95u3qtu3ln2a1bf",
      Username: mobile,
      Password: pass
    })
  })

  let data = await res.json()

  if(data.UserSub){
    alert("Signup successful")
    openLogin()
  } else {
    alert("Signup failed")
    console.log(data)
  }
}

// ---------- LOGIN ----------
async function login() {
  const mobile = liMobile.value.trim()
  const pass = liPass.value.trim()

  if(!mobile || !pass){
    alert("Enter credentials")
    return
  }

  const res = await fetch("https://cognito-idp.ap-south-1.amazonaws.com/", {
    method: "POST",
    headers: {
      "Content-Type": "application/x-amz-json-1.1",
      "X-Amz-Target": "AWSCognitoIdentityProviderService.InitiateAuth"
    },
    body: JSON.stringify({
      AuthFlow: "USER_PASSWORD_AUTH",
      ClientId: "201u029eenl95u3qtu3ln2a1bf",
      AuthParameters: {
        USERNAME: mobile,
        PASSWORD: pass
      }
    })
  })

  const data = await res.json()

  if (!data.AuthenticationResult) {
    alert("Login failed")
    console.log(data)
    return
  }

  // ✅ store token
  localStorage.setItem(
    "token",
    data.AuthenticationResult.IdToken
)

console.log(
    JSON.parse(
        atob(
            data.AuthenticationResult.IdToken.split(".")[1]
        )
    )
);
  console.log(localStorage.getItem("token"))

  front.classList.add("hidden")
  dashboard.classList.remove("hidden")

  loadTrades()
}

// ---------- LOGOUT ----------
function logout(){
  localStorage.removeItem("token")
  location.reload()
}

// ---------- ADD / UPDATE ----------
tradeForm.onsubmit = async e => {
  e.preventDefault()

  if(
    !date.value ||
    pair.selectedIndex === 0 ||
    !direction.value ||
    !sl.value ||
    riskfree.selectedIndex === 0 ||
    result.selectedIndex === 0 ||
    !pips.value
  ){
    alert("PLEASE FILL ALL DETAILS")
    return
  }

  let trade = {
  tradeId: editTradeId || Date.now().toString(),
  month: month.value,
  date: date.value,
  pair: pair.value,
  reason: reason.value,
  direction: direction.value,
  sl: sl.value,
  riskfree: riskfree.value,
  result: result.value,

  // ✅ PROFESSIONAL PIPS LOGIC
  pips:
    result.value === "TP HIT"
      ? Math.abs(+pips.value)

      : result.value === "SL HIT"
      ? -Math.abs(+sl.value)

      : 0,

  analysis: analysis.value.trim() || ""
}

  try {
    if(editTradeId){

  console.log("Sending Authorization Header");
  console.log(getAuthHeaders());

  await fetch(`${API_URL}/updateTrade`, {
    method: "PUT",
    headers: getAuthHeaders(),
    body: JSON.stringify(trade)
  })

  editTradeId = null

} else {

  console.log("Sending Authorization Header");
  console.log(getAuthHeaders());

  await fetch(`${API_URL}/addTrade`, {
    method: "POST",
    headers: getAuthHeaders(),
    body: JSON.stringify(trade)
  });

}

    tradeForm.reset()
    const today = new Date();

    month.selectedIndex = today.getMonth();
    loadTrades()

  } catch(err){
    console.error(err)
    alert("Error saving trade")
  }
}

// ---------- LOAD ----------
// ---------- LOAD ----------
async function loadTrades() {
  try {

    const response = await fetch(`${API_URL}/getTrades`, {
      method: "GET",
      headers: getAuthHeaders()
    });

    const list = await response.json();

    if (!Array.isArray(list)) {
      console.error(list);
      alert("Failed to load trades");
      return;
    }

    const selectedMonth = month.value;

    const trades = list.filter(t => t.month === selectedMonth);

    rows.innerHTML = "";

    let w = 0;
    let l = 0;
    let b = 0;
    let tp = 0;

    trades.forEach((t, i) => {

      const p = Number(t.pips);

      if (t.result === "TP HIT") w++;
      if (t.result === "SL HIT") l++;
      if (t.result === "BREAKEVEN") b++;

      tp += p;

      rows.innerHTML += `
      <tr>
        <td>${i + 1}</td>
        <td>${t.date}</td>
        <td>${t.pair}</td>
        <td>${t.reason}</td>
        <td>${t.direction}</td>
        <td>${t.sl}</td>
        <td>${t.riskfree}</td>
        <td>${t.result}</td>
        <td>${p}</td>
        <td>${t.analysis || ""}</td>
        <td>
          <button class="edit" onclick="editTrade('${t.tradeId}')">Edit</button>
          <button class="delete" onclick="deleteTrade('${t.tradeId}')">Delete</button>
        </td>
      </tr>`;
    });

    total.innerText = tp;

    accuracy.innerText =
      `Trade Accuracy: ${w + l ? ((w / (w + l)) * 100).toFixed(2) : 0}%`;

    drawChart(w, l, b);

  } catch (err) {
    console.error(err);
    alert("Error loading trades");
  }
}

// ---------- EDIT ----------
async function editTrade(id){

  const res = await fetch(`${API_URL}/getTrades`, {
    headers: getAuthHeaders()
  });

  const list = await res.json();

  const t = list.find(
    x => x.tradeId === id && x.month === month.value
  );

  if (!t) return;

  editTradeId = id;

  Object.keys(t).forEach(k => {
    const el = document.getElementById(k);
    if (el) {
      el.value = t[k];
    }
  });

}

// ---------- DELETE ----------
async function deleteTrade(id){
  if(!confirm("Delete this trade?")) return

  await fetch(`${API_URL}/deleteTrade`, {
    method:"DELETE",
    headers: getAuthHeaders(),
    body: JSON.stringify({
      tradeId: id
    })
  })

  loadTrades()
}

// ---------- CHART ----------
function drawChart(w,l,b){
  if(chart) chart.destroy()

  chart = new Chart(pie,{
    type:'pie',
    data:{
      labels:['Win','Loss','Breakeven'],
      datasets:[{
        data:[w,l,b],
        backgroundColor:['#16a34a','#dc2626','#ca8a04']
      }]
    }
  })
}