shader_type canvas_item;
uniform float distortion_scale = 0.04;
uniform float distortion_speed = 1.5;
uniform float flow_strength = 0.08;
void fragment() {
    float wave1 = sin(UV.y * 12.0 + TIME * distortion_speed) * 0.5;
    float wave2 = sin(UV.y * 7.0 - TIME * distortion_speed * 0.8) * 0.3;
    float wave3 = cos(UV.y * 18.0 + TIME * distortion_speed * 1.3) * 0.2;
    float horizontal_distort = (wave1 + wave2 + wave3) * distortion_scale;
    
    // Create a "breathing" effect that pulses the entire image
    float pulse = sin(TIME * distortion_speed * 0.5) * 0.015;
    float breathing_x = sin(UV.y * 6.0 + TIME * distortion_speed * 0.6) * pulse;
    float breathing_y = cos(UV.x * 6.0 - TIME * distortion_speed * 0.6) * pulse;
    
    // Diagonal wave pattern
    float diagonal = sin((UV.x + UV.y) * 10.0 + TIME * distortion_speed * 0.7) * distortion_scale * 0.5;
    
    // Create a liquid-like warping effect
    float liquid_x = sin(UV.y * 8.0 + TIME * distortion_speed) * cos(UV.x * 5.0 - TIME * distortion_speed * 0.5);
    float liquid_y = cos(UV.x * 8.0 - TIME * distortion_speed * 0.8) * sin(UV.y * 5.0 + TIME * distortion_speed * 0.6);
    
    // NEW: Smooth flowing distortion that moves groups of pixels horizontally
    // Uses low frequency waves to create large, smooth displacement zones
    float flow_wave1 = sin(UV.y * 3.0 + TIME * distortion_speed * 0.4);
    float flow_wave2 = cos(UV.y * 4.5 - TIME * distortion_speed * 0.3);
    float flow_wave3 = sin(UV.x * 2.0 + TIME * distortion_speed * 0.5);
    
    // Combine flow waves to create smooth horizontal displacement
    float horizontal_flow = (flow_wave1 * 0.5 + flow_wave2 * 0.3 + flow_wave3 * 0.2) * flow_strength;
    
    // Add vertical flow component for more organic movement
    float vertical_flow_pattern = sin(UV.x * 3.5 - TIME * distortion_speed * 0.35) * cos(UV.y * 2.5 + TIME * distortion_speed * 0.25);
    float vertical_flow = vertical_flow_pattern * flow_strength * 0.6;
    
    // Combine all distortions
    vec2 modified_uv = vec2(
        UV.x + horizontal_distort + breathing_x + diagonal + liquid_x * distortion_scale * 0.3 + horizontal_flow,
        UV.y + breathing_y + liquid_y * distortion_scale * 0.3 + vertical_flow
    );
    
    // Sample the texture
    COLOR = texture(TEXTURE, modified_uv);
}