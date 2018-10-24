#include <metal_stdlib>
#include <metal_texture>
using namespace metal;

#if !(__HAVE_FMA__)
#define fma(a,b,c) ((a) * (b) + (c))
#endif

struct VGlobals_Type
{
float3 _WorldSpaceCameraPos;
float4 hlslcc_mtx4x4unity_ObjectToWorld[4];
float4 hlslcc_mtx4x4unity_WorldToObject[4];
float4 hlslcc_mtx4x4unity_MatrixVP[4];
float4 _MainTex_ST;
};

struct Mtl_VertexIn
{
float4 POSITION0 [[ attribute(0) ]] ;
float3 NORMAL0 [[ attribute(1) ]] ;
float2 TEXCOORD0 [[ attribute(2) ]] ;
};

struct Mtl_VertexOut
{
float4 mtl_Position [[ position ]];
float2 TEXCOORD0 [[ user(TEXCOORD0) ]];
float4 TEXCOORD1 [[ user(TEXCOORD1) ]];
float3 TEXCOORD2 [[ user(TEXCOORD2) ]];
float3 NORMAL0 [[ user(NORMAL0) ]];
};

vertex Mtl_VertexOut xlatMtlMain(
constant VGlobals_Type& VGlobals [[ buffer(0) ]],
Mtl_VertexIn input [[ stage_in ]])
{
Mtl_VertexOut output;
float4 u_xlat0;
float4 u_xlat1;
float4 u_xlat2;
float u_xlat9;
u_xlat0 = input.POSITION0.yyyy * VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[1];
u_xlat0 = fma(VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[0], input.POSITION0.xxxx, u_xlat0);
u_xlat0 = fma(VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[2], input.POSITION0.zzzz, u_xlat0);
u_xlat1 = u_xlat0 + VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[3];
u_xlat0 = fma(VGlobals.hlslcc_mtx4x4unity_ObjectToWorld[3], input.POSITION0.wwww, u_xlat0);
u_xlat2 = u_xlat1.yyyy * VGlobals.hlslcc_mtx4x4unity_MatrixVP[1];
u_xlat2 = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[0], u_xlat1.xxxx, u_xlat2);
u_xlat2 = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[2], u_xlat1.zzzz, u_xlat2);
output.mtl_Position = fma(VGlobals.hlslcc_mtx4x4unity_MatrixVP[3], u_xlat1.wwww, u_xlat2);
output.TEXCOORD0.xy = fma(input.TEXCOORD0.xy, VGlobals._MainTex_ST.xy, VGlobals._MainTex_ST.zw);
output.TEXCOORD1 = u_xlat0;
u_xlat0.xyz = (-u_xlat0.xyz) + VGlobals._WorldSpaceCameraPos.xyzx.xyz;
u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
u_xlat9 = rsqrt(u_xlat9);
output.TEXCOORD2.xyz = float3(u_xlat9) * u_xlat0.xyz;
u_xlat0.x = dot(input.NORMAL0.xyz, VGlobals.hlslcc_mtx4x4unity_WorldToObject[0].xyz);
u_xlat0.y = dot(input.NORMAL0.xyz, VGlobals.hlslcc_mtx4x4unity_WorldToObject[1].xyz);
u_xlat0.z = dot(input.NORMAL0.xyz, VGlobals.hlslcc_mtx4x4unity_WorldToObject[2].xyz);
u_xlat9 = dot(u_xlat0.xyz, u_xlat0.xyz);
u_xlat9 = rsqrt(u_xlat9);
output.NORMAL0.xyz = float3(u_xlat9) * u_xlat0.xyz;
return output;
}


-- Hardware tier variant: Tier 1
-- Fragment shader for "metal":
Set 2D Texture "_MainTex" to slot 0
Set 2D Texture "_FlickerTex" to slot 1

Constant Buffer "FGlobals" (64 bytes) on slot 0 {
Vector4 _Time at 0
Vector4 _MainColor at 16
Vector4 _RimColor at 32
Float _RimPower at 48
Float _Brightness at 52
Float _Alpha at 56
Float _FlickerSpeed at 60
}

Shader Disassembly:
#include <metal_stdlib>
#include <metal_texture>
using namespace metal;

#if !(__HAVE_FMA__)
#define fma(a,b,c) ((a) * (b) + (c))
#endif

#ifndef XLT_REMAP_O
#define XLT_REMAP_O {0, 1, 2, 3, 4, 5, 6, 7}
#endif
constexpr constant uint xlt_remap_o[] = XLT_REMAP_O;
struct FGlobals_Type
{
float4 _Time;
float4 _MainColor;
float4 _RimColor;
float _RimPower;
float _Brightness;
float _Alpha;
float _FlickerSpeed;
};

struct Mtl_FragmentIn
{
float2 TEXCOORD0 [[ user(TEXCOORD0) ]] ;
float3 TEXCOORD2 [[ user(TEXCOORD2) ]] ;
float3 NORMAL0 [[ user(NORMAL0) ]] ;
};

struct Mtl_FragmentOut
{
float4 SV_Target0 [[ color(xlt_remap_o[0]) ]];
};

fragment Mtl_FragmentOut xlatMtlMain(
constant FGlobals_Type& FGlobals [[ buffer(0) ]],
sampler sampler_MainTex [[ sampler (0) ]],
sampler sampler_FlickerTex [[ sampler (1) ]],
texture2d<float, access::sample > _MainTex [[ texture(0) ]] ,
texture2d<float, access::sample > _FlickerTex [[ texture(1) ]] ,
Mtl_FragmentIn input [[ stage_in ]])
{
Mtl_FragmentOut output;
float u_xlat0;
float4 u_xlat1;
float3 u_xlat2;
u_xlat0 = dot(input.TEXCOORD2.xyz, input.NORMAL0.xyz);
u_xlat0 = clamp(u_xlat0, 0.0f, 1.0f);
u_xlat0 = (-u_xlat0) + 1.0;
u_xlat2.x = log2(u_xlat0);
u_xlat2.x = u_xlat2.x * FGlobals._RimPower;
u_xlat2.x = exp2(u_xlat2.x);
u_xlat2.xyz = u_xlat2.xxx * FGlobals._RimColor.xyz;
u_xlat1 = _MainTex.sample(sampler_MainTex, input.TEXCOORD0.xy);
u_xlat2.xyz = fma(u_xlat1.xyz, FGlobals._MainColor.xyz, u_xlat2.xyz);
u_xlat1.x = u_xlat1.w * FGlobals._Alpha;
u_xlat0 = u_xlat0 * u_xlat1.x;
output.SV_Target0.xyz = u_xlat2.xyz * float3(FGlobals._Brightness);
u_xlat2.xy = FGlobals._Time.xy * float2(FGlobals._FlickerSpeed);
u_xlat2.x = _FlickerTex.sample(sampler_FlickerTex, u_xlat2.xy).x;
output.SV_Target0.w = u_xlat2.x * u_xlat0;
return output;
}
