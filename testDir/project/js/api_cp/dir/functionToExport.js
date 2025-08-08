// ❌ 1. Propriété inexistante sur `console`
console.lung("should warn me that .lug is not a function");
//           ~~~  Property 'lug' does not exist on type 'Console'.

// ❌ 2. Appel de fonction inconnue
laz("text");
// ~~~  Cannot find name 'laz'.

// ❌ 3. Mauvaise syntaxe (manque de point-virgule + mot réservé)
let it go
//      ~~  ';' expected.
//     ~~~  'go' is not allowed here (interpreter-level)

// ❌ 4. Accès incomplet à une propriété
console.log(console.)
//                   ~  Expression expected (incomplete statement)

// ❌ 5. Mauvais type d’assignation
const num = "hello";
//             ~~~~~  Type '"hello"' is not assignable to type 'number'.

// ❌ 6. Déclaration redondante
let x = 5;
let x = 10;
//    ~  Cannot redeclare block-scoped variable 'x'.

// ❌ 7. Mauvaise fonction async
async function functionToExport() {
   await 123;
   //      ~~~  'await' expression is only allowed for Promises
}

export { functionToExport }
