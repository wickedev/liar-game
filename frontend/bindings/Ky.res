type options = {
  json: option<string>,
  limit: option<int>,
  method: option<string>,
  statusCodes: option<array<int>>,
  afterStatusCodes: option<array<int>>,
  maxRetryAfter: option<int>,
  headers: option<Js.Json.t>,
}

type optionWithURLSearchParam = {
  json: option<string>,
  limit: option<int>,
  method: option<string>,
  statusCodes: option<array<int>>,
  afterStatusCodes: option<array<int>>,
  maxRetryAfter: option<int>,
  headers: option<Js.Json.t>,
  //
  body: Webapi.Url.URLSearchParams.t,
}

type optionWithFormData = {
  json: option<string>,
  limit: option<int>,
  method: option<string>,
  statusCodes: option<array<int>>,
  afterStatusCodes: option<array<int>>,
  maxRetryAfter: option<int>,
  headers: option<Js.Json.t>,
  //
  body: Fetch.FormData.t,
}

type optionWithObject = {
  json: option<string>,
  limit: option<int>,
  method: option<string>,
  statusCodes: option<array<int>>,
  afterStatusCodes: option<array<int>>,
  maxRetryAfter: option<int>,
  headers: option<Js.Json.t>,
  //
  body: string,
}

type optionWithFile = {
  json: option<string>,
  limit: option<int>,
  method: option<string>,
  statusCodes: option<array<int>>,
  afterStatusCodes: option<array<int>>,
  maxRetryAfter: option<int>,
  headers: option<Js.Json.t>,
  timeout: option<int>,
  //
  body: Webapi.Blob.t,
}

@module("ky") @scope("default")
external postWithURLSearchParam: (
  string,
  option<optionWithURLSearchParam>,
) => Js.Promise.t<Fetch.Response.t> = "post"
@module("ky") @scope("default")
external postWithObject: (string, option<optionWithObject>) => Js.Promise.t<Fetch.Response.t> =
  "post"

@module("ky") @scope("default")
external postWithForm: (string, option<optionWithFormData>) => Js.Promise.t<Fetch.Response.t> =
  "post"

@module("ky") @scope("default")
external getWithURLSearchParam: (
  string,
  option<optionWithURLSearchParam>,
) => Js.Promise.t<Fetch.Response.t> = "get"

@module("ky") @scope("default")
external getWithForm: (string, option<optionWithFormData>) => Js.Promise.t<Fetch.Response.t> = "get"

@module("ky") @scope("default")
external get: string => Js.Promise.t<Fetch.Response.t> = "get"

@module("ky") @scope("default")
external getWithOptions: (string, options) => Js.Promise.t<Fetch.Response.t> = "get"