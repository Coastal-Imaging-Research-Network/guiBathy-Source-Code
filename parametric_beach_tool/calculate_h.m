function [data] = calculate_h(data)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
warning('off','MATLAB:nearlySingularMatrix');
debug = 0;
for iy = 1:length(data.y)
    %disp(['y = ',num2str(data.y(iy))])
    [~,nearest_y_shore_idx] = min(abs(data.yshore - data.y(iy)));
    xindx = data.x > data.xshore(nearest_y_shore_idx) & data.x <= data.xoff;
%         if data.y(iy) > 790
%             1
%         end
    for ix = 1:length(data.x)

        if ismember(data.x(ix),data.x(xindx))
            %disp(['x = ',num2str(data.x(ix))])
            min_dx = 2.0;
            dx0 = data.x(ix) - data.xshore(nearest_y_shore_idx);
            if dx0 >= min_dx
                dx = dx0;
            else
                dx = min_dx;
            end
           
            tolerance = floor(data.feature_res); %for convergence, dx_mean must be within tolerance;
            convergence = 0;
            while convergence == 0
                segment_indices = data.yshore >= data.y(iy)-dx & ...
                    data.yshore <= data.y(iy) + dx;
                y_shore_segment = data.yshore(segment_indices);
                x_shore_segment = data.xshore(segment_indices);
                x_mean = mean(x_shore_segment);
                dx_mean = (data.x(ix) - x_mean);
                if abs(dx_mean - dx) < tolerance
                    convergence = 1;
                elseif dx == min_dx
                    convergence = 1;
                else
                    if dx > dx_mean
                        dx = dx - tolerance;
                    elseif dx < dx_mean
                        dx = dx + tolerance;
                    end
                end
            end
            
            a = polyfit(y_shore_segment,x_shore_segment,1);
            x_best_fit = y_shore_segment * a(1) + a(2);
            
            best_fit_slope = 1.0/a(1);
            best_fit_intercept = -1.0*a(2)/a(1);
            
            normal_slope = -1.0/best_fit_slope;
            normal_intercept = data.y(iy) - normal_slope*data.x(ix);
            
            if debug == 1
                figure(1)
                plot(y_shore_segment,x_best_fit,'b');
                hold on
                plot(y_shore_segment,x_shore_segment,'r*')
                pause
                clf
            end
            
            x_s = (normal_intercept - best_fit_intercept) / (best_fit_slope - normal_slope);
            y_s = best_fit_slope*x_s + best_fit_intercept;
            
            if debug == 2
                figure(1)
                plot(y_shore_segment,x_best_fit,'b');
                hold on
                plot(y_s,x_s,'k.')
                plot(data.y(iy),data.x(ix),'ro')
                pause
                clf
            end
            
            y_b_bound1 = normal_slope*data.xbar_min + normal_intercept;
            y_b_bound2 = normal_slope*data.xbar_max + normal_intercept;
            
            if y_b_bound1 < data.ybar_min & y_b_bound2 < data.ybar_min
                data.h(iy,ix) = NaN;
                continue
            elseif y_b_bound1 > data.ybar_max & y_b_bound2 > data.ybar_max
                data.h(iy,ix) = NaN;
                continue 
            else 
                if y_b_bound2 >= y_b_bound1
                    bar_candidate_mask = data.ybar >= y_b_bound1 - tolerance & ...
                        data.ybar <= y_b_bound2 + tolerance;
                elseif y_b_bound2 < y_b_bound1
                    bar_candidate_mask = data.ybar >= y_b_bound2 - tolerance & ...
                        data.ybar <= y_b_bound1 + tolerance;
                end
            end
            y_b_bar_candidates = data.ybar(bar_candidate_mask);
            x_b_candidates = data.xbar(bar_candidate_mask);
            
            y_b_normal_candiates = normal_slope*x_b_candidates + normal_intercept;
            y_candidate_offset = abs(y_b_bar_candidates - y_b_normal_candiates);
            
            [~,min_offset_idx] = min(y_candidate_offset);
            y_b = y_b_bar_candidates(min_offset_idx);
            x_b = x_b_candidates(min_offset_idx);
            
            s_b = sqrt((y_b - y_s).^2 + (x_b - x_s).^2);
            
            y_off = normal_slope*data.xoff + normal_intercept;
            
            s_off = sqrt((data.xoff - x_s).^2 + (y_off - y_s).^2);
            
            s_p = sqrt((data.y(iy) - y_s).^2 + (data.x(ix) - x_s).^2);
            
            s = 0:1:round(s_off);
            
            s_prime = s_off;
            h_prime = data.hoff;
            gamma = 1.0;
            betasave = data.beta_off;
%             while gamma >= 0
                [gamma,kappa] = solve_boundary_equations(data,s_prime);
%               if gamma > 0
%                   data.beta_off = data.beta_off - 0.0005;
%               end
%             end
%             if abs(betasave - data.beta_off) > 0
%                disp(['data.beta_off has been changed to ',num2str(data.beta_off)])
%             end
%             if gamma > 0
%                 data.beta_off = data.hoff/data.xoff;
%             end
            h0 = composite_profile_func(s,data.beta_off, gamma, kappa);
            %xdiff = 500;
            %nn = 0;
            %xlim = 100.0;
            %while xdiff > xlim
            theta = phase_structure_func(s,h0,s_off);
            
            [~,idtemp] = min(abs(s - s_b));
            psi = theta(idtemp);
            coscut = cut_oscillation(theta,psi,s,idtemp,data.numbars);
            data.hsea = h0(coscut.iddsea);
            data.hshore = h0(coscut.iddshore);
            
            S_exp_component_values = S_exp_component_func(h0,data.hsea);
            
            [~,idtemp] = max(S_exp_component_values);
            s_max = s(idtemp);
            
            ss = spatial_bar_variability_func(s,h0,s_max,s_off,data.hsea,data.hshore);
            
            [~,idtemp] = min(abs(h0 - data.hsea));
            if h0(idtemp) <= data.hsea
                s_discontinuity = s(idtemp);
            else
                s_discontinuity = s(idtemp-1);
            end
            discontinuity_slope = compute_discontinuity_slope(s,ss,s_discontinuity);
            
            %%%exp_decay_coefficients = solve_exp_coefficients(ss,s,s_discontinuity,discontinuity_slope);
            
            %%%s_seaward_exp_decay = exp_decay_func(s,exp_decay_coefficients(1),exp_decay_coefficients(2));
            
            %%%ss(s>s_discontinuity) = s_seaward_exp_decay(s>s_discontinuity);
            
           % theta = phase_structure_func(s,h0,s_off);
            
           % [~,idtemp] = min(abs(s - s_b));
           % psi = theta(idtemp);
           % cosinefun = cut_oscillation(theta,psi,s,idtemp);
            
            h_barred = generate_h_barred(ss,theta,psi);
%             [~,idtemp] = min(h_barred);
%             xpeak = s(idtemp);
%             xdiff = abs(xpeak - s_b);
%             if xpeak-s_b < -1.0*xlim
%                 data.hsea = data.hsea + 0.5;
%                 disp(['shift hsea to ',num2str(data.hsea)])
%             elseif xpeak-s_b > xlim
%                 data.hsea = data.hsea - 0.5;
%                 disp(['shift hsea to ',num2str(data.hsea)])
%             end
%             nn = nn + 1;
%             if nn == 11
%                 break
%             end
%             end
            
            barred_composite_bathymetry = h0 + h_barred;
            [~,idtemp] = min(abs(s - s_p));
            data.h(iy,ix) = barred_composite_bathymetry(idtemp);
        end
    end 
end

